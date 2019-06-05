function [ H ] = affineTransform( keyPointsSrc,keyPointsDst )
% 
% function [ H ] = affineTransform( keyPointsSrc,keyPointsDst )
% 
% Function   : affineTransform
% 
% Purpose    : find the affine transform matrix from first image key location 
%              to the other imgage key points.
% Parameters : keyPointsSrc          - first image key points.
%              keyPointsDst          - the transform matrix.
%
% Return     : H   - The transform matrix.
%
numPts = length(keyPointsSrc(1,:));
M = zeros(numPts,6); % points reordered matrix
p2 = zeros(numPts,1); % projected points
% arange vector p2 and matrix M
for i=1:2:numPts
	M(i,1:3) = [keyPointsSrc(1,i) keyPointsSrc(2,i) 1];
    M(i+1,4:6) = [keyPointsSrc(1,i) keyPointsSrc(2,i) 1];
    p2(i) = keyPointsDst(1,i);
    p2(i+1) = keyPointsDst(2,i);
end
% solve
h = M\p2;
% rearrange as a matrix
H = zeros(3);
H(1,1:3) = h(1:3);
H(2,1:3) = h(4:6);
H(9) = 1;

end

