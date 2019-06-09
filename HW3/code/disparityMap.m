function [dispmap] = disparityMap(I_left, I_right, w, DisparityMax)
%
% function [dispmap] = disparityMap(I_left, I_right, w)
%
% Function   : disparityMap
%
% Purpose    : make a disparity map of I_left and I_right, by windows of
%              size w
%
% Parameters : I_left          - left input Image.
%              I_right         - right input Image.
%              w               - window size.
%
% Return     : dispmap         - 2D matrix of x_left - x_right.
%

% pad images with zeros to avoid edges effects:
padsize = floor(w/2);
I_left = padarray(I_left, [padsize padsize]);
I_right = padarray(I_right, [padsize padsize]);

% initialization:
sz = size(I_left(:,:,1));
rows_num = sz(1) - (w-1);
cols_num = sz(2) - (w-1);
dispmap = zeros(rows_num,cols_num);

for i=1:rows_num % row
    % parallell line in the right image for rectified images
    scan_line = I_right(i:i+(w-1),:,:);
    
    fprintf('disparityMap pre-W %d / %d \n', i,rows_num);
    
    % run throughout all the x_lefts:
    for j=1:cols_num % column
        
        % window of the left image to compare
        window = I_left(i:i+(w-1),j:j+(w-1),:);
        
        % the relevant x_rights for checking on the right image
        idxs = j-DisparityMax:j+(w-1);
        idxs(idxs<1) = [];
        
        % calculate the ssds for the line
        ssd = windowMatching(scan_line(:,idxs,:), window);
        
        % take the most similar x_right
        [~, x_right] = min(ssd(1,:));
        x_right = idxs(1) - 1 + x_right;
        
        % disparity = x_left - x_right
        d = j - x_right;
        dispmap(i,j) = d;
        
    end
    
end

end

