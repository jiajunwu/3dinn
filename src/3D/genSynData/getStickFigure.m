function stickStruct = getStickFigure(varargin)

% function stickStruct = getStickFigure(varargin)
% 
% Parameters:
%   scale, class, indexPermute

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
elseif strcmp(para.class, 'human')
	stickStruct.np = 11;
	stickStruct.nbasis = 14;
	stickStruct.edgeAdj{1} = [1,2; 2,3; 3,4; 4,5; 5,6; 6,7; 7,8; 8,9; 9,10; 10,11];
	stickStruct.baseShape{1} = zeros(3,stickStruct.np,stickStruct.nbasis);
	stickStruct.baseShape{1}(:,:,1) = [-3,0,0; -3,1,0; -3,2,0; -2,3,0; -1,4,0; 0,4,0; 1,4,0; 2,3,0; 3,2,0; 3,1,0;3,0,0]';
	stickStruct.baseShape{1}(:,:,2) = -[1,0,0; 0.5,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,0,0]';   % left wrist
	stickStruct.baseShape{1}(:,:,3) = -[0,1,0; 0,0.5,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,0,0]';
	stickStruct.baseShape{1}(:,:,4) = [0,0,1; 0,0,0.5; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,0,0]';
	stickStruct.baseShape{1}(:,:,5) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0.5,0,0; 1,0,0]';    % right wrist
	stickStruct.baseShape{1}(:,:,6) = -[0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0.5,0; 0,1,0]';
	stickStruct.baseShape{1}(:,:,7) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0.5; 0,0,1]';
	stickStruct.baseShape{1}(:,:,8) = -[1,0,0; 1,0,0; 1,0,0; 0.5,0,0;   0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,0,0]';   % left albow
	stickStruct.baseShape{1}(:,:,9) = -[0,1,0; 0,1,0; 0,1,0; 0,0.5,0;   0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,0,0]';
	stickStruct.baseShape{1}(:,:,10) = [0,0,1; 0,0,1; 0,0,1; 0,0,0.5;   0,0,0; 0,0,0; 0,0,0;    0,0,0; 0,0,0; 0,0,0; 0,0,0]';
	stickStruct.baseShape{1}(:,:,11) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0;    0.5,0,0; 1,0,0; 1,0,0; 1,0,0]';   % right albow
	stickStruct.baseShape{1}(:,:,12) = -[0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0;    0,0.5,0; 0,1,0; 0,1,0; 0,1,0]';
	stickStruct.baseShape{1}(:,:,13) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0;    0,0,0.5; 0,0,1; 0,0,1; 0,0,1]';
	stickStruct.baseShape{1}(:,:,14) = [-1,0,0; -1,0,0; -1,0,0; -1,0,0;   -1,0,0; 0,0,0; 1,0,0;    1,0,0; 1,0,0; 1,0,0; 1,0,0]';
    stickStruct.alphaRange{1} = [-4,1;-4,2;0,3;     -4,1;-4,2;0,3;     -4,1;-4,2;0,3;   -4,1;-4,2;0,3;    0.4,0.9];
    stickStruct.alphaGSif = true;
%     stickStruct.alphaRange{1} = [-4,1;-4,2;-3,3;     -4,1;-4,2;-3,3;     -4,1;-4,2;-3,3;   -4,1;-4,2;-3,3;    0.4,0.9];
	stickStruct.scaleRange{1} = [10,55];
    stickStruct.tranRange{1} = [-40,40;-20,100];
%     stickStruct.thetaRange{1} = [pi,pi; -0.2*pi,0.2*pi; 0,0];
    stickStruct.thetaRange{1} = [pi,pi; -0.2*pi,0.2*pi; 0,0];
    stickStruct.fRange{1} = [1e10,1e10];    % no perspective 
    stickStruct.h = 320;
    stickStruct.w = 240;
    % stickStruct.indices{1} = [3,7,2,8,1,11,4,10,5,9,6];
    stickStruct.indices{1} = [6,9,5,10,4,11,1,8,2,7,3];
    stickStruct.shapecheckFunc = @check_human;
elseif strcmp(para.class, 'bird')
	stickStruct.np = 15;
	stickStruct.nbasis = 16;
	stickStruct.edgeAdj{1} = [1,15; 2,15; 3,15; 4,15; 1,5; 4,6; 5,7; 6,8; 7,13; 8,13; 13,9; 13,10; 8,11; 8,12; 13,14];
	stickStruct.baseShape{1} = zeros(3,stickStruct.np,stickStruct.nbasis);
	stickStruct.baseShape{1}(:,:,1) = [3,0,0; 2.5,0.5,-0.5; 2.5,0.5,0.5; 2,1,0;     2,-1,0; 1,1,0; 1,-1,0; -1,1,0;      -1,-3,-1; -1,-3,1; -1,1,-2; -1,1,2;     -1,-1,0; -3,0,0; 2.5,0.5,0]';

	stickStruct.baseShape{1}(:,:,2) = [0,0,0; 0,0.5,0; 0,0.5,0; 0,1,0;   0,-1,0; 0,1,0; 0,-1,0; 0,1,0;   0,-1,0; 0,-1,0; 0,1,0; 0,1,0;   0,-1,0;0,0,0; 0,0.5,0;]';  % height of bird
	stickStruct.baseShape{1}(:,:,3) = [0,1,0; 0,0.5,0; 0,0.5,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0;0,0,0; 0,0.5,0;]'; % location of beak
	stickStruct.baseShape{1}(:,:,4) = [0,1,0; 0,1,0; 0,1,0; 0,1,0;   0,1,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0;0,0,0; 0,1,0;]'; % location of crown
	stickStruct.baseShape{1}(:,:,5) = [0,0,0; 0,0,-1; 0,0,1; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0;0,0,0;0,0,0;]'; % distance between eyes
	stickStruct.baseShape{1}(:,:,6) = [1,0,0; 0.5,0,0; 0.5,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0;0,0,0; 0.5,0,0;]'; % length of head

	stickStruct.baseShape{1}(:,:,7) = [1,0,0; 1,0,0; 1,0,0; 1,0,0;   1,0,0; 1,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0;0,0,0; 1,0,0;]'; % length of body
	stickStruct.baseShape{1}(:,:,8) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0;-1,0,0; 0,0,0;]'; % length of tail

	stickStruct.baseShape{1}(:,:,9) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 1,0,0; 1,0,0;    0,0,0;0,0,0;0,0,0;]'; % location of wing
	stickStruct.baseShape{1}(:,:,10) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,1,0; 0,1,0;   0,0,0;0,0,0;0,0,0;]';
	stickStruct.baseShape{1}(:,:,11) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,-1; 0,0,1;    0,0,0;0,0,0;0,0,0;]';

	stickStruct.baseShape{1}(:,:,12) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   1,0,0; 1,0,0; 0,0,0; 0,0,0;   0,0,0;0,0,0;0,0,0;]'; % location of leg
	stickStruct.baseShape{1}(:,:,13) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,-1,0; 0,-1,0; 0,0,0; 0,0,0;   0,0,0;0,0,0;0,0,0;]'; % 
	stickStruct.baseShape{1}(:,:,14) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,-1; 0,0,1; 0,0,0; 0,0,0;   0,0,0;0,0,0;0,0,0;]'; % 
	stickStruct.baseShape{1}(:,:,15) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0;0,1,0;0,0,0;]'; % height of tail
    stickStruct.baseShape{1}(:,:,16) = [0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0; 0,0,0; 0,0,0; 0,0,0;   0,0,0;0,0,0;0,1,0;]'; % loc forehead

	stickStruct.alphaRange{1} = [-0.5,0.8;-1,1;-1,1;-0.3,0.3;-0.5,1;    -1, 1;-1.5,1.5;   -1.3,1.3;-1.3,1.3;-1.3,1.3;   -1,1; -1,1; -0.5,0.5;   -1,1;-0.2,0.2;]/3;
    stickStruct.alphaGSif = true;
	stickStruct.scaleRange{1} = [20,50];
    stickStruct.tranRange{1} = [-40,40;-120,40];
    stickStruct.thetaRange{1} = [1.0*pi,1.15*pi; 0,2*pi; 0,0];
    stickStruct.fRange{1} = [1e10,1e10];    % no perspective
    stickStruct.h = 320;
    stickStruct.w = 240;    
    stickStruct.indices{1} = [2,7,11,5,15,10,4,1,8,12,9,13,3,14,6];
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















