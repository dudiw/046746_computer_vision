close all;
%%

url_data = 'Depth with stereo data';
dir = fullfile(url_data,'input');
dir_gt = fullfile(url_data,'groundtruth');
num_tests = ['03'; '04'; '07'];

W = [5,11,21]; % window sizes
DisparityMax = 60;

for i=1:3 % % for each image
    
    % left and right images:
    file = fullfile(dir,['test' num_tests(i,:) '_']);
    left_im = imread([file 'l.png']);
    right_im = imread([file 'r.png']);
    figure()
    subplot(2,3,1);
    imshow(left_im);
    title("left image");
    subplot(2,3,2);
    imshow(right_im);
    title("right image");
    
    % show ground truth:
    file_gt = fullfile(dir_gt,['test' num_tests(i,:) '.mat']);
    load(file_gt);
    subplot(2,3,3);
    imagesc(groundtruth);
    title ("ground truth");
    axis image; axis off;
    
    for j=1:3 % for each window size
        
        % calculate and show the disparity map:
        dmap = disparityMap(left_im,right_im,W(j),DisparityMax);
        save([file num2str(W(j)) '_dmap_out'],'dmap');
        rmse = RMSE(dmap, groundtruth); % error
        subplot(2,3,j+3);
        imagesc(dmap);
        caxis([min(groundtruth(:)) max(groundtruth(:))]); % color map of GT
        axis image; axis off;
        title("w = " + num2str(W(j)) + ", RMSE = " + num2str(rmse));
        
    end
    
end