function gaussianPyramid(...)
  local dst, src, scales
  local args = {...}
  if select('#',...) == 3 then
    dst = args[1]
    src = args[2]
    scales = args[3]
  elseif select('#',...) == 2 then
    dst = {}
    src = args[1]
    scales = args[2]
  end
  if src:nDimension() == 2 then
    for i = 1, #scales do
      dst[i] = dst[i] or torch.Tensor()
      dst[i]:resize(src:size(1) * scales[i], src:size(2) * scales[i])
    end
  elseif src:nDimension() == 3 then
    for i = 1, #scales do
      dst[i] = dst[i] or torch.Tensor()
      dst[i]:resize(src:size(1), src:size(2) * scales[i], src:size(3) * scales[i])
    end
  end
  local kernel = image.gaussian1D{width = 3, normalize = true}

  local padH = math.floor(kernel:size(1) / 2)
  local padW = padH

  local gaussianFilter = nn.Sequential()
  gaussianFilter:add(nn.SpatialZeroPadding(padW, padW, padH, padH))
  gaussianFilter:add(nn.SpatialConvolutionMap(nn.tables.oneToOne(1), kernel:size(1), 1))
  gaussianFilter:add(nn.SpatialConvolution(1, 1, 1, kernel:size(1), 1))

  for i = 1, 1 do 
    gaussianFilter.modules[2].weight[i]:copy(kernel)
    gaussianFilter.modules[3].weight[1][i]:copy(kernel)
  end

  gaussianFilter.modules[2].bias:zero()
  gaussianFilter.modules[3].bias:zero()

  local tmp = src
  for i = 1, #scales do
    if scales[i] == 1 then
      dst[i][{}] = tmp
    else
      image.scale(dst[i], tmp, 'simple')
    end

    local reshaped = dst[i]:reshape(dst[i]:size(1), 1, dst[i]:size(2), dst[i]:size(3))

    local coef = gaussianFilter:updateOutput(reshaped.new():resizeAs(reshaped):fill(1))
    coef = coef:clone()

    local filtered = gaussianFilter:updateOutput(reshaped)
    local filteredNormalized = nn.CDivTable():updateOutput{filtered, coef}

    tmp = filteredNormalized:reshape(dst[i]:size(1), dst[i]:size(2), dst[i]:size(3))
  end
  return dst    
end

function customLCN(inputs, kernel, threshold, thresval)
  assert (inputs:dim() == 4, "Input should be of the form nSamples x nChannels x width x height")

  local padH = math.floor(kernel:size(1)/2)
  local padW = padH

  -- normalize the kernel
  kernel:div(kernel:sum())

  local meanestimator = nn.Sequential()
  meanestimator:add(nn.SpatialZeroPadding(padW, padW, padH, padH))
  meanestimator:add(nn.SpatialConvolutionMap(nn.tables.oneToOne(1), kernel:size(1), 1))
  meanestimator:add(nn.SpatialConvolution(1, 1, 1, kernel:size(1), 1))

  local stdestimator = nn.Sequential()
  stdestimator:add(nn.Square())
  stdestimator:add(nn.SpatialZeroPadding(padW, padW, padH, padH))
  stdestimator:add(nn.SpatialConvolutionMap(nn.tables.oneToOne(1), kernel:size(1), 1))
  stdestimator:add(nn.SpatialConvolution(1, 1, 1, kernel:size(1)))
  stdestimator:add(nn.Sqrt())

  for i = 1,1 do 
    meanestimator.modules[2].weight[i]:copy(kernel)
    meanestimator.modules[3].weight[1][i]:copy(kernel)
    stdestimator.modules[3].weight[i]:copy(kernel)
    stdestimator.modules[4].weight[1][i]:copy(kernel)
  end
  meanestimator.modules[2].bias:zero()
  meanestimator.modules[3].bias:zero()
  stdestimator.modules[3].bias:zero()
  stdestimator.modules[4].bias:zero()

  local coef = meanestimator:updateOutput(inputs.new():resizeAs(inputs):fill(1))
  coef = coef:clone()

  local localSums = meanestimator:updateOutput(inputs)
  local adjustedSums = nn.CDivTable():updateOutput{localSums, coef}
  local meanSubtracted = nn.CSubTable():updateOutput{inputs, adjustedSums}

  local localStds = stdestimator:updateOutput(meanSubtracted)
  local adjustedStds = nn.CDivTable():updateOutput{localStds, coef}
  local thresholdedStds = nn.Threshold(threshold, thresval):updateOutput(adjustedStds)
  local outputs = nn.CDivTable():updateOutput{meanSubtracted, thresholdedStds}

  return outputs
end

-- Build a pyramid and run LCN on each of the inputs 
function buildPyramidsAndLCN(convInputs, opt) 
  local bankNum = #opt.bankSize

  -- opt.bankSize[1] is the biggest size.
  -- From one image, we get multiple banks of different sizes (pyramid)
  local convInputsNormalized = torch.Tensor(convInputs:size(1), 
    bankNum, opt.chnNum, opt.pyramidSize[1][1] * opt.pyramidSize[1][2]):zero()

  local pyramid = {}
  for j = 1, bankNum do
    pyramid[j] = torch.Tensor(convInputs:size(1), 
      opt.chnNum, opt.pyramidSize[j][1], opt.pyramidSize[j][2])
  end

  local timer = torch.Timer()
  print('Building '..convInputs:size(1)..' pyramids...')

  -- Build pyramids
  local imageSize = math.max(convInputs:size(3), convInputs:size(4))
  local pyScales = {}
  for i = 1, bankNum do
    pyScales[i] = opt.bankSize[i] / imageSize
  end

  for i = 1, opt.chnNum do
    chnPyramid = {}
    gaussianPyramid(chnPyramid, convInputs[{{}, i, {}, {}}], pyScales)

    for j = 1, bankNum do
      pyramid[j][{{}, i, {}, {}}] = chnPyramid[j]
    end
  end
  print('Built pyramids : ' .. timer:time().real .. ' seconds')

  -- Define the normalization neighborhood:
  local neighborhood = image.gaussian1D(7)
  
  -- Use spatial contrastive normalization (LCN) to filter the input
  print('Applying LCN to '..convInputs:size(1)..' pyramids...')
  timer:reset()
  for scale = 1, bankNum do
    for chn = 1, opt.chnNum do
      convInputsNormalized[{{}, scale, chn, 
        {1, pyramid[scale]:size(3) * pyramid[scale]:size(4)}}] = 
        customLCN(pyramid[scale][{{}, chn, {}, {}}]:
        reshape(pyramid[scale]:size(1), 1, pyramid[scale]:size(3), 
        pyramid[scale]:size(4)), neighborhood, 1, 1)
    end
  end
  print('Applied LCN : ' .. timer:time().real .. ' seconds')

  return convInputsNormalized
end

