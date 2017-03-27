function X = alpha2X3D(alpha, baseShape)

X = sum(bsxfun(@times,baseShape,shiftdim(alpha,-2)),3);

end