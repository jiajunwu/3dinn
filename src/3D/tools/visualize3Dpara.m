function im = visualize3Dpara(alpha, sincosTheta, tran, f, baseShape, edgeAdj, varargin)

% function im = visualize3Dpara(alpha, sincosTheta, tran, f, baseShape, varargin)
% 
% Parameters:
%       alpha: nbasis x 1
%       sincosTheta: 6 x 1
%       tran: 2x1
%       f: 1
%       baseShape: 3 x np x nbasis
%       edgeAdj: nedge x 2
% 
% Addition parameters:
%    h, w, lineWidth, addNode, circSize
% 
% Example:
%   stickStruct = getStickFigure('class', 'chair');
%   im = visualize3Dpara(alpha, sincosTheta, tran, f, stickStruct.baseShape{1}, stickStruct.edgeAdj{1});

para.h = 320;
para.w = 240;
para.lineWidth = 6;
para.addNode = true;
para.circSize = 8;
para = propval(varargin, para);

theta = sctheta2theta(sincosTheta);
x = alpha2x_proj(tran,alpha,theta,f,baseShape, 'w', para.w, 'h',para.h);
im = renderImage(x,edgeAdj,'addNoise',false,'noiseLevel',0,'h',para.h,'w',para.w,'lineWidth',6,'parallel',false,...
    'addNode',para.addNode, 'circSize', para.circSize);

end


