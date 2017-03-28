function show3DLD(X, adj, color, varargin)

% function show3DLD(X, adj, color, varargin)
% 
% This file is created by Tianfan Xue (tfxue@mit.edu).

para.showNumber = false;
para.showAxis = true;
para.fontsize = 20;
para = propval(varargin, para);

if (nargin == 2) || isempty(color)
    color = [1,0,0];
end

X1 = X(1,:); X2 = X(2,:); X3 = X(3,:);
plot3(X1,X2,X3,'.','Color',color,'MarkerSize',10);
hold on;
line(X1(adj)', X2(adj)', X3(adj)', 'Color', color,'LineWidth',3);
if para.showNumber 
    for i=1:size(X,2)
        text(X1(i),X2(i),X3(i),sprintf('%d',i),'FontSize',para.fontsize);
    end
end
if para.showAxis
    xlabel('x');
    ylabel('y');
    zlabel('z');
end
axis equal

end

