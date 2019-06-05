function [stitchI] = templateStitching(I,tmplt)
%
% function [stitchI] = templateStitching(I,tmplt)
%
% Function   : templatestitching
%
% Purpose    : stitch and replace aligned template to an image I 
%                         
% Parameters : I          - input Image.
%              tmplt      - the template that will be stitched.
%
% Return     : stitchI     - the stitched image.
%

% make template and image to have the same size
tmplt = padarray(tmplt, size(I)-size(tmplt), 'post'); 

% RGB
R = I(:,:,1); G = I(:,:,2); B = I(:,:,3);
Rt = tmplt(:,:,1); Gt = tmplt(:,:,2); Bt = tmplt(:,:,3);

% mask
mask = Rt>0 | Gt>0 | Bt>0;
R(mask) = Rt(mask); G(mask) = Gt(mask); B(mask) = Bt(mask);

% make the stitched image
stitchI =  cat(3, R, G, B);
end

