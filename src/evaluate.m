function evaluate(resPath, wwwPath, class, width, height)

if strcmp(class, 'chair') || strcmp(class, 'bed') 
  param_length = [5, 6, 12, 14];
elseif strcmp(class, 'swivelchair') || strcmp(class, 'sofa')
  param_length = [7, 8, 14, 16];
end

load(resPath, 'outputs');
numInst = size(outputs, 1);
alphaPred = outputs(:, 1 : param_length(1));
finvPred = outputs(:, (param_length(1) + 1) : param_length(2));
sincosThetaPred = outputs(:, (param_length(2) + 1) : param_length(3));
sincosThetaPred(:, 3) = 0;
sincosThetaPred(:, 6) = 1;
tranPred = outputs(:, (param_length(3) + 1) : param_length(4));

addpath(fullfile('3D', 'genSynData'));
addpath(fullfile('3D', 'tools'));
stickStruct = getStickFigure('class', class);

for i = 1 : numInst 
  im = visualize3Dpara(alphaPred(i, :)', sincosThetaPred(i, :)', ... 
    tranPred(i, :)', 1 ./ finvPred(i, :), stickStruct.baseShape{1}, ... 
    stickStruct.edgeAdj{1}, 'h', height, 'w', width, 'lineWidth', 6);
  imwrite(im, fullfile(wwwPath, sprintf('%08d.jpg', i)));
end

end
