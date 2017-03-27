function theta = sctheta2theta(sincosTheta)

% function theta = sctheta2theta(sincosTheta)

sincosTheta = sincosTheta ./ repmat(sqrt(sincosTheta(1:3,:).^2 + sincosTheta(4:6,:).^2),[2,1]);
theta = asin(sincosTheta(1:3,:));
mask = sincosTheta(4:6,:) < 0;
theta(mask) = pi - theta(mask);

end

