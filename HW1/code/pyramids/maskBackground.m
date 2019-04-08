function [ I ] = maskBackground( input,mask,background )
% 
% function [ I ] = maskBackground( input,mask,background ) 
% 
% Function   : maskBackground
% 
% Purpose    : Apply the background to the input image via binary mask.
% 
% Parameters : input      - The input image.
%            : mask       - A binary mask to retain foreground information.
%            : background - A background image to replace the original background.
% Return     : I          - The input image with swapped background.
%

I = mask .* input + (1 - mask) .* background;
