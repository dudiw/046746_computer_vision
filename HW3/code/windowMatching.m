function [ ssd ] = windowMatching(I, template)
%
% function [ ssd ] = windowMatching(template, I)
%
% Function   : windowMatching
%
% Purpose    : calculating the sum squared differences of the template with
%              the image I.
%
% Parameters : template    - template window to be running on the image I.
%              I           - input Image.
%
% Return     : ssd         - 2D matrix of sum squared differences of the
%                            template with the image I.
%
szt = size(template(:,:,1));
% final ssd size
sz = size(I(:,:,1)) - (szt - 1);
ssdi = zeros (1,sz(1)*sz(2));
% for each color
for i=1:3
    tmpli = double(template(:,:,i));
    Ii = double(im2col(I(:,:,i), szt));
    % ssd function
    fun = @(block_struct) sum((block_struct.data - tmpli(:)).^2);
    % I1 column size
    szti = [szt(1)*szt(2) 1];
    % calculate ssd
    b =  blockproc(Ii, szti ,fun);
    ssdi = ssdi + b;
end
% rearrange
ssd = col2im(ssdi,[1 1], sz);
end

