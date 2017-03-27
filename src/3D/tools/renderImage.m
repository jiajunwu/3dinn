function imlist = renderImage(x, edgeAdj, varargin)

% function imlist = renderImage(x, edgeAdj, varargin)
% 
% Parameter: addNoise, addNode, outputStep, nRandLine, nRandTri,
% noiseLevel, h, w, scale, lineWidth, circSize

para.addNoise = true;
para.addNode = false;
para.outputStep = 1000;
para.nRandLine = 15;
para.nRandTri = 3;
para.noiseLevel = 0.1;
para.h = 64;
para.w = 64;
para.scale = 2;
para.lineWidth = 3;
para.circSize = 4;
para.parallel = true;
para = propval(varargin, para);

h=para.h; w=para.w;
hb = h*para.scale; wb = w*para.scale;
nShape = size(x,3);
circSize = para.circSize;
imlist = zeros(h,w,1,nShape);
edgeColor = [0,0,0];
np = size(x,2);
if para.parallel
    parfor i=1:nShape
    % for i=1:nShape
        im = ones(hb,wb,3);
        coor = x(1:2,:,i) * para.scale;
        if para.addNode
            im = insertShape(im, 'FilledCircle', [coor',circSize*ones(np,1)], 'Color',edgeColor);
        end
        im = insertShape(im, 'Line', [coor(1,edgeAdj(:,1))',coor(2,edgeAdj(:,1))',...
            coor(1,edgeAdj(:,2))',coor(2,edgeAdj(:,2))'], 'Color', edgeColor, 'LineWidth', para.lineWidth);

        if para.addNoise
            xyStart = bsxfun(@times,rand(para.nRandLine,2),[wb,hb]);
            xyLen = rand(para.nRandLine,1) * (hb/8) + hb/8; angle = rand(para.nRandLine,1)*(2*pi);
            xyEnd = bsxfun(@plus, xyStart, bsxfun(@times,xyLen,[cos(angle),sin(angle)]));
            im = insertShape(im, 'Line', [xyStart,xyEnd], 'LineWidth', 1, 'Color', edgeColor);
            xyCenter = bsxfun(@plus, bsxfun(@times,rand(para.nRandTri,2),[wb/2,hb/2]), [wb/4,hb/4]);
            xyLen = rand(para.nRandTri,1) * (hb/8) + hb/8; angle = rand([para.nRandTri,1,3])*(2*pi);
            xyEnd = reshape(bsxfun(@plus, xyCenter, bsxfun(@times,xyLen,[cos(angle),sin(angle)])),[para.nRandTri,6]);
            im = insertShape(im, 'FilledPolygon', xyEnd, 'Opacity', 1, 'Color', repmat(rand(para.nRandTri,1)*0.5,[1,3]));
            im = im + para.noiseLevel * randn(size(im));
        end

        imlist(:,:,:,i) = imresize(im(:,:,1),[h,w]);
        if mod(i,para.outputStep) == 0
            fprintf(1,'shape %d\n', i);
        end
    end
else
    for i=1:nShape
        im = ones(hb,wb,3);
        coor = x(1:2,:,i) * para.scale;
        if para.addNode
            im = insertShape(im, 'FilledCircle', [coor',circSize*ones(np,1)], 'Color',edgeColor);
        end
        im = insertShape(im, 'Line', [coor(1,edgeAdj(:,1))',coor(2,edgeAdj(:,1))',...
            coor(1,edgeAdj(:,2))',coor(2,edgeAdj(:,2))'], 'Color', edgeColor, 'LineWidth', para.lineWidth);

        if para.addNoise
            xyStart = bsxfun(@times,rand(para.nRandLine,2),[wb,hb]);
            xyLen = rand(para.nRandLine,1) * (hb/8) + hb/8; angle = rand(para.nRandLine,1)*(2*pi);
            xyEnd = bsxfun(@plus, xyStart, bsxfun(@times,xyLen,[cos(angle),sin(angle)]));
            im = insertShape(im, 'Line', [xyStart,xyEnd], 'LineWidth', 1, 'Color', edgeColor);
            xyCenter = bsxfun(@plus, bsxfun(@times,rand(para.nRandTri,2),[wb/2,hb/2]), [wb/4,hb/4]);
            xyLen = rand(para.nRandTri,1) * (hb/8) + hb/8; angle = rand([para.nRandTri,1,3])*(2*pi);
            xyEnd = reshape(bsxfun(@plus, xyCenter, bsxfun(@times,xyLen,[cos(angle),sin(angle)])),[para.nRandTri,6]);
            im = insertShape(im, 'FilledPolygon', xyEnd, 'Opacity', 1, 'Color', repmat(rand(para.nRandTri,1)*0.5,[1,3]));
            im = im + para.noiseLevel * randn(size(im));
        end

        imlist(:,:,:,i) = imresize(im(:,:,1),[h,w]);
        if mod(i,para.outputStep) == 0
            fprintf(1,'shape %d\n', i);
        end
    end
    
end

end

