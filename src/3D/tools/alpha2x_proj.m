function x = alpha2x_proj(tran,alpha,theta,f, baseShape, varargin)

% function x = alpha2x_proj(tran,alpha,theta,f, baseShape, varargin)
% 
% Paramters:h, w

para.h = 64;
para.w = 64;
para = propval(varargin, para);
h = para.h; h2 = h/2;
w = para.w; w2 = w/2;

np = size(baseShape,2);
nShape = size(alpha,2);
x = zeros([2,np,nShape]);
for i=1:nShape
    Rx = [1,0,0; 0,cos(theta(1,i)),-sin(theta(1,i));0,sin(theta(1,i)),cos(theta(1,i))];
    Ry = [cos(theta(2,i)),0,sin(theta(2,i)); 0,1,0;-sin(theta(2,i)),0,cos(theta(2,i))];
    Rz = [cos(theta(3,i)),-sin(theta(3,i)),0; sin(theta(3)),cos(theta(3,i)),0;0,0,1];
    R = Rx*Ry*Rz;
    
    coor3 = sum(bsxfun(@times,baseShape,shiftdim(alpha(:,i),-2)),3);
    coor3RT = bsxfun(@plus,  R * coor3, [tran(:,i);0]);
    x(:,:,i) = bsxfun(@plus, bsxfun(@times, coor3RT(1:2,:), 1./(1+coor3RT(3,:)/f(i))), [w2;h2]);
end

end

