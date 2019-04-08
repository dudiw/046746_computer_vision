function [ pyramids ] = laplacianPyramids( I,nLevel )
% 
% function [ pyramids ] = laplacianPyramids( image,title ) 
% 
% Function   : laplacianPyramids
% 
% Purpose    : Decompose a gray-level image to Laplacian Pyramid.
% 
% Parameters : I          - The input image.
%              nLevel     - The number of pyramid levels.
%
% Return     : pyramids   - The Laplacian Pyramids.
%

pyramids = cell(nLevel, 1);
pyramids{1} = I;

for i = 2:nLevel
  sigma = 2^(i);
  kernel = fspecial('gaussian', sigma*5, sigma); 
  pyramids{i} = imfilter(I, kernel, 'symmetric');
  
  pyramids{i - 1} = pyramids{i - 1} - pyramids{i};
end
