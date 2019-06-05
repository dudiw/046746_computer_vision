function [ H, inliers ] = RANSAC( keyPointsSrc,keyPointsDst )
%
% function [ H ] = RANSAC( keyPointsSrc,keyPointsDst )
%
% Function   : RANSAC
%
% Purpose    : find the affine transform matrix from first image key location
%              to the other imgage key points using RANSAC algorithm
% Parameters : keyPointsSrc          - first image key points.
%              keyPointsDst          - second image key points.
%
% Return     : H   - The transform matrix.
%
numPts = length(keyPointsSrc(1,:));
max = 6;
for i = 1:1000
    % a - find affine transform matrix of random 6 key points
    ids = randi(numPts,1,6);
    H_t = affineTransform(keyPointsSrc(:,ids),keyPointsDst(:,ids));
    % b - calculate the projected key points
    newKeyPointsDst = H_t * [keyPointsSrc ; ones(1,numPts)];
    % c - update to a better affine transform
    inliers_t = sqrt((newKeyPointsDst(1,:) - keyPointsDst(1,:)).^2 + (newKeyPointsDst(2,:) - keyPointsDst(2,:)).^2) < 5;
    if(sum(inliers_t) > max)
        max = length(find(inliers_t));
        inliers = keyPointsSrc(:,inliers_t);
        H = affineTransform(keyPointsSrc(:,inliers_t),keyPointsDst(:,inliers_t));
    end
end
