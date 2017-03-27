-------------------------------------------------------------------------------
print '==> Initializing...'
package.path = '?.lua;' .. package.path

require 'torch'
require 'image'

require 'nn'
require 'cunn'
require 'cutorch'

require 'nn.Scale'

dofile 'pyramidLCN.lua'

-------------------------------------------------------------------------------

local cmd = torch.CmdLine()

cmd:text()
cmd:text('3D-INN evaluation script')
cmd:text()
cmd:text('Options:')
cmd:option('-seed',             0,            'Random seed')
cmd:option('-gpuID',            1,            'ID of GPUs to use')
cmd:option('-batchSize',        16,           'Batch Size') 
cmd:option('-class',            'chair',      'Model class for evaluation')
cmd:text()  

local opt = cmd:parse(arg or {})

cutorch.setDevice(opt.gpuID)
torch.manualSeed(opt.seed)
math.randomseed(opt.seed)
cutorch.manualSeedAll(opt.seed)

--------------------------------------------------------------------------------
-- constants
opt.chnNum = 3     -- RGB
opt.inputWidth = 240   
opt.inputHeight = 320
opt.heatmapWidth = 30
opt.heatmapHeight = 40

opt.bankSize = {320, 160, 80} -- input sizes (long edge) for each bank
opt.pyramidSize = {}          -- pyramid sizes for each scale
for i = 1, #opt.bankSize do
    local scale = opt.bankSize[i] / math.max(opt.inputWidth, opt.inputHeight)
    opt.pyramidSize[i] = {math.floor(scale * opt.inputHeight), 
        math.floor(scale * opt.inputWidth)}
end

if opt.class == 'chair' then
  opt.paramNum = 14
  opt.paramMin = {30, -70, -70, -15, 0, 1/450, -1, -1, -1, -1, -1, -1, -60, -80}
  opt.paramMax = {50, 100, 100, 100, 150, 1/120, 1, 1, 1, 1, 1, 1, 60, 80}
  opt.paramWeight = torch.ones(opt.paramNum)
  opt.paramWeight[6] = 10
elseif opt.class == 'swivelchair' then
  opt.paramNum = 16
  opt.paramMin = {35, -42.5, -85, -42.5, -42.5, -25.5, 0, 1/450, -1, -1, -1, -1, -1, -1, -60, -80}
  opt.paramMax = {85, 42.5, 212.5, 85, 65, 51, 51, 1/120, 1, 1, 1, 1, 1, 1, 60, 80}
  opt.paramWeight = torch.ones(opt.paramNum)
  opt.paramWeight[8] = 10
elseif opt.class == 'bed' then
  opt.paramNum = 14
  opt.paramMin = {30, -50.4, -21, -21, -21, 1/450, -1, -1, -1, -1, -1, -1, -80, -60}
  opt.paramMax = {42, 21, 63, 21, 42, 1/200, 1, 1, 1, 1, 1, 1, 80, 60}
  opt.paramWeight = torch.ones(opt.paramNum)
  opt.paramWeight[6] = 10
elseif opt.class == 'sofa' then
  opt.paramNum = 16
  opt.paramMin = {30, -21, 0, -21, -42, -42, 0, 1/450, -1, -1, -1, -1, -1, -1, -80, -60}
  opt.paramMax = {42, 21, 84, 42, 84, 42, 84, 1/200, 1, 1, 1, 1, 1, 1, 80, 60}
  opt.paramWeight = torch.ones(opt.paramNum)
  opt.paramWeight[8] = 10
end

opt.mean = torch.Tensor({129.67, 114.43, 107.26})
opt.mean:mul(1 / 255)

--------------------------------------------------------------------------------
-- paths
opt.dataPath = paths.concat('..', 'data')
opt.modelPath = paths.concat('..', 'models', opt.class .. '_model.torch')

opt.wwwPath = paths.concat('..', 'www', opt.class)
opt.resPath = paths.concat('..', 'results')
opt.genPath = paths.concat('..', 'gen')

os.execute('mkdir -p ' .. opt.wwwPath)
os.execute('mkdir -p ' .. opt.resPath)
os.execute('mkdir -p ' .. opt.genPath)

opt.resPath = paths.concat(opt.resPath, opt.class .. '.mat')
opt.scalePath = paths.concat(opt.genPath, opt.class .. '_scale.torch')
opt.inputPath = paths.concat(opt.genPath, opt.class .. '_inputs.torch')

-------------------------------------------------------------------------------
function unnormOutput(params, opt)
  for i = 1, opt.paramNum do
    if opt.paramMax[i] ~= opt.paramMin[i] then
      params[i] = opt.paramMin[i] + params[i] / 
        opt.paramWeight[i] * (opt.paramMax[i] - opt.paramMin[i])
    else
      params[i] = opt.paramMax[i]
    end
  end

  return params
end

-- load data and build lcn
function loadData(opt)
  local imageList = paths.concat(opt.dataPath, opt.class .. '.txt')
  local imageNum = 0
  local imageNames = {}
  for line in io.lines(imageList) do
    imageNum = imageNum + 1
    imageNames[imageNum] = line
  end

  print('generate scales')
  local oriCoords = torch.zeros(imageNum, 2, 2)
  local images = torch.Tensor(imageNum, opt.chnNum, opt.inputHeight, opt.inputWidth)

  for i = 1, imageNum do
    local oriIm = image.load(paths.concat(opt.dataPath, imageNames[i]))
    if oriIm:size(1) == 1 and opt.chnNum == 3 then
      oriIm = torch.repeatTensor(oriIm, 3, 1, 1)
    end
    for k = 1, opt.chnNum do
      local maxValue = oriIm[k]:max()
      local minValue = oriIm[k]:min()
      local imScaled = oriIm[k]:clone():add(-minValue):mul(1.0 / (maxValue - minValue))
      images[i][k] = image.scale(imScaled, opt.inputWidth, opt.inputHeight)
      images[i][k]:add(-opt.mean[k])
    end

    -- get new im trans from im
    local scaleX = opt.heatmapWidth / oriIm:size(3)
    local scaleY = opt.heatmapHeight / oriIm:size(2)
    local scale = math.min(scaleX, scaleY)
    local x1, x2, y1, y2
    local newTrans
    if scaleX < scaleY then
      x1 = 1
      x2 = opt.heatmapWidth
      y1 = math.floor((opt.heatmapHeight - oriIm:size(2) * scale) / 2 + 1 + 0.5)
      y2 = math.floor(y1 + scale * oriIm:size(2) - 1 + 0.5)
    else
      x1 = math.floor((opt.heatmapWidth - oriIm:size(3) * scale) / 2 + 1 + 0.5)
      x2 = math.floor(x1 + scale * oriIm:size(3) - 1 + 0.5)
      y1 = 1
      y2 = opt.heatmapHeight
    end

    x1 = math.min(math.max(x1, 1), opt.heatmapWidth)
    x2 = math.min(math.max(x2, 1), opt.heatmapWidth)
    y1 = math.min(math.max(y1, 1), opt.heatmapHeight)
    y2 = math.min(math.max(y2, 1), opt.heatmapHeight)

    local newTrans = torch.Tensor({{scale, 0, x1 - scale}, {0, scale, y1 - scale}})

    -- use trans to get the new coords
    oriCoords[i][1] = newTrans * torch.Tensor({1, 1, 1})
    oriCoords[i][2] = newTrans * torch.Tensor({oriIm:size(3), oriIm:size(2), 1})
    oriCoords[i][1][1] = math.floor(oriCoords[i][1][1] + 0.5)
    oriCoords[i][1][2] = math.floor(oriCoords[i][1][2] + 0.5)
    oriCoords[i][2][1] = math.floor(oriCoords[i][2][1] + 0.5)
    oriCoords[i][2][2] = math.floor(oriCoords[i][2][2] + 0.5)
    oriCoords[i][1][1] = math.min(math.max(oriCoords[i][1][1], 1), opt.heatmapWidth)
    oriCoords[i][1][2] = math.min(math.max(oriCoords[i][1][2], 1), opt.heatmapHeight)
    oriCoords[i][2][1] = math.min(math.max(oriCoords[i][2][1], 1), opt.heatmapWidth)
    oriCoords[i][2][2] = math.min(math.max(oriCoords[i][2][2], 1), opt.heatmapHeight)
  end
  
  torch.save(opt.scalePath, oriCoords)
    
  -- build pyramid and do lcn
  print('generate normalized input')
  local input = buildPyramidsAndLCN(images, opt)
  torch.save(opt.inputPath, input)
end

-------------------------------------------------------------------------------
-- measure function, save all predictions for evaluation
function test(opt)
  local time = sys.clock()

  local model = torch.load(opt.modelPath)
  model:evaluate()

  -- load test input/output
  local inputs = torch.load(opt.inputPath)
  local scales = torch.load(opt.scalePath)
  local outputs = torch.zeros(inputs:size(1), opt.paramNum)

  -- test over given dataset
  for t = 1, inputs:size(1), opt.batchSize do
    -- disp progress
    xlua.progress(t, inputs:size(1))

    -- create mini batch
    local batchStart = t
    local batchEnd = math.min(t + opt.batchSize - 1, inputs:size(1))
    local batchIndices = {batchStart, batchEnd}
    local batchInputs = inputs[{batchIndices}]:cuda()
    local batchScales = scales[{batchIndices}]:cuda()

    local batchOutputs = model:forward({batchInputs, batchScales}):clone():double()
    for i = batchStart, batchEnd do
      outputs[i] = unnormOutput(batchOutputs[i - batchStart + 1], opt)
    end
  end

  -- timing
  time = sys.clock() - time
  time = time / inputs:size(1)
  print("<evaluater> time to test 1 sample = " .. (time * 1000) .. 'ms')

  -- save .mat file
  require('fb.mattorch').save(opt.resPath, {outputs = outputs}) 
end

-------------------------------------------------------------------------------
print '==> prepare data'
loadData(opt)

-------------------------------------------------------------------------------
print '==> evaluate'
test(opt)

local cmd = 'matlab -nodisplay -nodesktop -nojvm -r ' .. 
  '"evaluate(\'' .. opt.resPath .. '\', \'' .. opt.wwwPath .. 
  '\', \'' .. opt.class .. '\', ' .. opt.inputWidth ..
  ', ' .. opt.inputHeight .. '); exit;"'
print('Testing: ' .. cmd)
os.execute(cmd)

