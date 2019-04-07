function [ I ] = reconstructImage( pyramids )
% 
% function [ I ] = reconstructImage( pyramids ) 
% 
% Function   : reconstructImage
% 
% Purpose    : Reconstruct an image from its Laplacian Pyramids.
% 
% Parameters : pyramids   - The Laplacian Pyramids of the original image.
%
% Return     : I          - The reconstructed image.
%

nLevel = numel(pyramids);
I = pyramids{nLevel};

for i = nLevel - 1 : -1 : 1
    I = I + pyramids{i};
end
