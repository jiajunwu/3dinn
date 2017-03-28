function stickStruct = getStickFigure(varargin)

% function stickStruct = getStickFigure(varargin)
% 
% Parameters:
%   scale, class, indexPermute
%
% Fields of stickStruct
%   - nclass: ignore this field, this is always 1
%   - edgeAdj: M x 2 adjacent matrices, where M is the number of edges
%   - baseShape: 3 x N x B, where N is number of nodes, and B is number of
%   bases. baseShape(:,:,1) is the mean base shape, and baseShape(:, :, i)
%   are the additional deformation. See the demo code below for more
%   details.
%   - np: number of nodes
%   - nbasis: number of bases
%   - alphaGSif: ignore this field
%   - scaleRange: Range of scaling in camera parameters. 
%   - thetaRange: Range of rotation angles in camera parameters. 
%   - tranRange: Range of translation in camera parameters. 
%   - fRange: Range of focal length
%   - h: the height of the input image
%   - w: the with of the input image
%   - indices: normally, it should be 1:N. For some models, it is not to
%   deal with some indices inconsistency.
% 
% Demo code:
% 
% cd [gitroot]/src
% addpath(genpath('3D'));
% addpath(genpath('nn'));
% stickStruct = getStrickFigure('class', 'chair');
% subplot(2,3,1); show3DLD(stickStruct.baseShape{1}(:,:,1), stickStruct.edgeAdj{1});
% title('Mean shape');
% for i = 2:5
%     subplot(2,3,i); show3DLD(stickStruct.baseShape{1}(:,:,1) + ...
%         stickStruct.baseShape{1}(:,:,i), stickStruct.edgeAdj{1});
%     title(sprintf('The %d-th deformation', i-1));
% end

para.scale = [];
para.class = 'chair';
para.indexPermute = true;
para = propval(varargin, para);

stickStruct.nclass = 1;
stickStruct.edgeAdj = cell(1,1);
stickStruct.baseShape = cell(1,1);
stickStruct.alphaRange = cell(1,1);
if ~isempty(para.scale) && (para.scale == 64)
    stickStruct.scaleRange = [9,11]/2;
elseif ~isempty(para.scale) && (para.scale == 128)
    stickStruct.scaleRange = [9,11]/2;
end

if strcmp(para.class, 'chair')
	stickStruct.np = 10;
	stickStruct.nbasis = 5;
	stickStruct.edgeAdj{1} = [1,5;2,6;3,7;4,8;5,6;6,7;7,8;5,8;8,9;7,10;9,10];
	stickStruct.baseShape{1} = zeros(3,stickStruct.np,stickStruct.nbasis);
	stickStruct.baseShape{1}(:,:,1) = [-1,-2,1; 1,-2,1; 1,-2,-1; -1,-2,-1;     -1,0,1; 1,0,1; 1,0,-1; -1,0,-1;     -1,2,-1; 1,2,-1]';
	stickStruct.baseShape{1}(:,:,2) = [0,-1,0;0,-1,0;0,-1,0;0,-1,0; 0,0,0;0,0,0;0,0,0;0,0,0; 0,0,0;0,0,0]';
	stickStruct.baseShape{1}(:,:,3) = [0,0,0;0,0,0;0,0,0;0,0,0; 0,0,0;0,0,0;0,0,0;0,0,0; 0,1,0;0,1,0]';
	stickStruct.baseShape{1}(:,:,4) = [-1,0,0;1,0,0;1,0,0;-1,0,0; -1,0,0;1,0,0;1,0,0;-1,0,0; -1,0,0;1,0,0]';
	stickStruct.baseShape{1}(:,:,5) = [-1,0,1;1,0,1;1,0,-1;-1,0,-1; 0,0,0;0,0,0;0,0,0;0,0,0; 0,0,0;0,0,0]';
	stickStruct.alphaRange{1} = [-1.4,2;-1.4,2;-0.3,1;0,0.3];
    stickStruct.alphaGSif = false;
	stickStruct.scaleRange{1} = [30,50];
    stickStruct.thetaRange{1} = [1.0*pi,1.15*pi; 0,2*pi; 0,0];
    stickStruct.tranRange{1} = [-60,60;-80,80];
    stickStruct.fRange{1} = [120,450];
    stickStruct.h = 320;
    stickStruct.w = 240;    
    stickStruct.indices{1} = 1:10;
    stickStruct.shapecheckFunc = [];
elseif strcmp(para.class, 'swivelchair')
	stickStruct.np = 13;
	stickStruct.nbasis = 7;
	stickStruct.edgeAdj{1} = [1,6;2,6;3,6;4,6;5,6;  6,7;8,9;9,10;8,11;10,11;  11,12;12,13;10,13];
	stickStruct.baseShape{1} = zeros(3,stickStruct.np,stickStruct.nbasis);
    tmpScale = 1.2;
	stickStruct.baseShape{1}(:,:,1) = [0.3090*tmpScale,-1.5,0.9511*tmpScale; -0.8090*tmpScale,-1.5,0.5878*tmpScale; -0.8090*tmpScale,-1.5,-0.5878*tmpScale; 
        0.3090*tmpScale,-1.5,-0.9511*tmpScale; 1.0000*tmpScale,-1.5,0.0000*tmpScale;
	    0,-1.5,0; 0,0,0;     -1,0,1; 1,0,1; 1,0,-1; -1,0,-1; -1,1.5,-1; 1,1.5,-1]';
	stickStruct.baseShape{1}(:,:,2) = [0,-1,0; 0,-1,0; 0,-1,0; 0,-1,0; 0,-1,0;    0,-1,0; 0,0,0;  
	    0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;]';
	stickStruct.baseShape{1}(:,:,3) = [0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0;  
	    0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,1,0; 0,1,0;]';
	stickStruct.baseShape{1}(:,:,4) = [0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0;  
	    -1,0,0; 1,0,0; 1,0,0; -1,0,0; -1,0,0; 1,0,0;]';
	stickStruct.baseShape{1}(:,:,5) = [0.3090,0,0.9511; -0.8090,0,0.5878; -0.8090,0,-0.5878; 0.3090,0,-0.9511; 1.0000,0,0.0000;
	    0,0,0; 0,0,0;  0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;]';     % wheels
	stickStruct.baseShape{1}(:,:,6) = [-0.9511,0,0.3090; -0.5878,0,-0.8090; 0.5878,0,-0.8090; 0.9511,0,0.3090; 0.0000,0,1.0000;
	    0,0,0; 0,0,0;  0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;]';     % wheels
    stickStruct.baseShape{1}(:,:,7) = [0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;
	    0,1,0; 0,0,0;  0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;]';     % wheels
	stickStruct.alphaRange{1} = [-0.5,0.5; -1,2.5; -0.5,1; -0.5,0.8; -0.3,0.6; 0,0.6];
    stickStruct.alphaGSif = false;
	stickStruct.scaleRange{1} = [35,85];
    stickStruct.tranRange{1} = [-60,60;-80,80];
    stickStruct.thetaRange{1} = [1.0*pi,1.15*pi; 0,2*pi; 0,0];
    stickStruct.fRange{1} = [120,450];
    stickStruct.h = 320;
    stickStruct.w = 240;    
    stickStruct.indices{1} = 1:13;
    stickStruct.shapecheckFunc = [];
elseif strcmp(para.class, 'table')
	stickStruct.np = 8;
	stickStruct.nbasis = 6;
	stickStruct.edgeAdj{1} = [1,2;2,4;1,3;3,4;1,5;2,6;3,7;4,8];
	stickStruct.baseShape{1} = zeros(3,stickStruct.np,stickStruct.nbasis);
	stickStruct.baseShape{1}(:,:,1) = [-1,1,-1; 1,1,-1; -1,1,1; 1,1,1; -1,-1,-1; 1,-1,-1; -1,-1,1; 1,-1,1;]';
	stickStruct.baseShape{1}(:,:,2) = [0,1,0;0,1,0;0,1,0;0,1,0; 0,-1,0;0,-1,0;0,-1,0;0,-1,0;]';
	stickStruct.baseShape{1}(:,:,3) = [-1,0,0;1,0,0;-1,0,0;1,0,0; -1,0,0;1,0,0;-1,0,0;1,0,0;]';
    stickStruct.baseShape{1}(:,:,4) = [0,0,-1;0,0,-1;0,0,1;0,0,1; 0,0,-1;0,0,-1;0,0,1;0,0,1;]';
    stickStruct.baseShape{1}(:,:,5) = [0,0,0;0,0,0;0,0,0;0,0,0; 1,0,0;-1,0,0;1,0,0;-1,0,0;]';
    stickStruct.baseShape{1}(:,:,6) = [0,0,0;0,0,0;0,0,0;0,0,0; 0,0,-1;0,0,-1;0,0,1;0,0,1;]';
	stickStruct.alphaRange{1} = [-0.3,0.3;-0.6,2.5;-0.3,1;  0,1;0,0.2];
    stickStruct.alphaGSif = false;
	stickStruct.scaleRange{1} = [30,42];
    stickStruct.tranRange{1} = [-80,80; -60,60];
%     stickStruct.tranRange{1} = [-10,10; -120,120];
    stickStruct.thetaRange{1} = [1.0*pi,1.3*pi; -0.23*pi,0.23*pi; 0,0];
    stickStruct.fRange{1} = [120,450];
    stickStruct.h = 320;
    stickStruct.w = 240;         
    stickStruct.indices{1} = 1:8;
    stickStruct.shapecheckFunc = [];   
elseif strcmp(para.class, 'bed')
	stickStruct.np = 10;
	stickStruct.nbasis = 5;
	stickStruct.edgeAdj{1} = [1,5;2,6;3,7;4,8;3,4;5,6;6,7;7,8;5,8;8,9;7,10;9,10];
	stickStruct.baseShape{1} = zeros(3,stickStruct.np,stickStruct.nbasis);
	stickStruct.baseShape{1}(:,:,1) = [-1.00,-1.00,2.00; 1.00,-1.00,2.00; 1.00,-1.00,-2.00; -1.00,-1.00,-2.00; -1.00,0.00,2.00; 1.00,0.00,2.00; 
        1.00,0.00,-2.00; -1.00, 0.00,-2.00; -1.00,1.00,-2.00; 1.00,1.00,-2.00]';
	stickStruct.baseShape{1}(:,:,2) = [0,0,1; 0,0,1; 0,0,-1; 0,0,-1; 0,0,1; 0,0,1; 0,0,-1; 0,0,-1; 0,0,-1; 0,0,-1]';     % length
	stickStruct.baseShape{1}(:,:,3) = [-1,0,0; 1,0,0; 1,0,0; -1,0,0; -1,0,0; 1,0,0; 1,0,0; -1,0,0; -1,0,0; 1,0,0]';     % width
    stickStruct.baseShape{1}(:,:,4) = [0,-1,0; 0,-1,0; 0,-1,0; 0,-1,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0]';     % height of leg
    stickStruct.baseShape{1}(:,:,5) = [0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,1,0; 0,1,0]';     % height of back
	stickStruct.alphaRange{1} = [-1.2,0.5; -0.5,1.5; -0.5,0.5; -0.5,1];
    stickStruct.alphaGSif = false;
	stickStruct.scaleRange{1} = [30,42];
    stickStruct.tranRange{1} = [-80,80; -60,60];
%     stickStruct.tranRange{1} = [-10,10; -120,120];
    stickStruct.thetaRange{1} = [1.0*pi,1.25*pi;  -0.75*pi,0.75*pi; 0,0];
    stickStruct.fRange{1} = [200,450];
    stickStruct.h = 320;
    stickStruct.w = 240;         
    % stickStruct.indices{1} = [2,7,9,4,1,6,8,3,5,10];
    stickStruct.indices{1} = [2,7,6,1,4,9,8,3,5,10];
    stickStruct.shapecheckFunc = [];  
elseif strcmp(para.class, 'sofa')
	stickStruct.np = 14;
	stickStruct.nbasis = 7;
	stickStruct.edgeAdj{1} = [1,5;2,6;3,7;4,8;5,6;6,7;7,8;5,8;8,9;7,10;9,10;11,12;12,5;13,14;14,6];
	stickStruct.baseShape{1} = zeros(3,stickStruct.np,stickStruct.nbasis);
	stickStruct.baseShape{1}(:,:,1) = [-2.00,-2.00,1.00; 2.00,-2.00,1.00; 2.00,-2.00,-1.00; -2.00,-2.00,-1.00; -2.00,0.00,1.00; 
        2.00,0.00,1.00; 2.00,0.00,-1.00; -2.00,0.00,-1.00; -2.00,2.00,-1.00; 2.00,2.00,-1.00; -2.00,1.00,-1.00; -2.00,1.00,1.00; 2.00,1.00,-1.00; 2.00,1.00,1.00]';
	stickStruct.baseShape{1}(:,:,2) = [0,0,1; 0,0,1; 0,0,-1; 0,0,-1; 0,0,1;     0,0,1; 0,0,-1; 0,0,-1; 0,0,-1; 0,0,-1;     0,0,-1; 0,0,1; 0,0,-1; 0,0,1]';     % length
    stickStruct.baseShape{1}(:,:,3) = [-1,0,0; 1,0,0; 1,0,0; -1,0,0; -1,0,0;     1,0,0; 1,0,0; -1,0,0; -1,0,0; 1,0,0;     -1,0,0; -1,0,0; 1,0,0; 1,0,0]';     % width
    stickStruct.baseShape{1}(:,:,4) = [0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,1,0; 0,1,0;     0,0.5,0; 0,0.5,0; 0,0.5,0; 0,0.5,0]';     % height of back
    stickStruct.baseShape{1}(:,:,5) = [0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;     0,1,0; 0,1,0; 0,1,0; 0,1,0]';     % height of arm rest
    stickStruct.baseShape{1}(:,:,6) = [0,-1,0; 0,-1,0; 0,-1,0; 0,-1,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;     0,0,0; 0,0,0; 0,0,0; 0,0,0]';     % height of leg
    stickStruct.baseShape{1}(:,:,7) = [0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,0,0; 0,0,0;     0,0,0; 0,0,-1; 0,0,0; 0,0,-1]';     % loc of arm rest
    stickStruct.alphaRange{1} = [-0.5,0.5; 0,2; -0.5,1; -1,2; -1,1; 0,2];
    stickStruct.alphaGSif = false;
	stickStruct.scaleRange{1} = [30,42];
    stickStruct.tranRange{1} = [-80,80; -60,60];
    stickStruct.thetaRange{1} = [1.0*pi,1.15*pi; -0.5*pi,0.5*pi; 0,0];
    stickStruct.fRange{1} = [200,450];
    stickStruct.h = 320;
    stickStruct.w = 240;         
    stickStruct.indices{1} = [2,9,8,1,4,11,10,3,7,14,5,6,12,13];
    stickStruct.shapecheckFunc = [];
end

if para.indexPermute
    forwardidx = stickStruct.indices{1};
    revertidx = zeros(size(forwardidx));
    revertidx(stickStruct.indices{1}) = 1:length(stickStruct.indices{1});
    stickStruct.baseShape{1} = stickStruct.baseShape{1}(:,revertidx,:);
    stickStruct.edgeAdj{1} = forwardidx(stickStruct.edgeAdj{1});
end



if ~isempty(para.scale) && (para.scale == 64)
    stickStruct.h = 64;
    stickStruct.w = 64;
elseif ~isempty(para.scale) && (para.scale == 128)
    stickStruct.h = 128;
    stickStruct.w = 128; 
end

end















