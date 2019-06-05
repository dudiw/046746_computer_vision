function [ rmse ] = RMSE(im1,im2)
%
% function [ rmse ] = RMSE(im1,im2)
%
% Function   : RMSE
%
% Purpose    : calculate Root Mean Square deviation between 2 Matrices
%
% Parameters : im1         - first Input Image.
%              im2         - second input Image.
% 
% Return     : dispmap         - 2D matrix of x_left - x_right.
%

num_elem = length(im1(:));
rmse  = sqrt(sum((im1(:) - im2(:)).^2)/num_elem);

end

