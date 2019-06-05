function [] = ImageStitching()

close all;

path_sift = fullfile("..","sift");

% % Compile SIFT
% path_src = fullfile("..","code");
% 
% cd(path_sift);
% sift_compile();
% cd(path_src);

addpath(path_sift);

% preproccesing
dirname = "Stop Images";
StopSigns = cell(4,1);
descriptors = cell(4,1);
frames = cell(4,1);
H = cell(3,1);

% image stitching algorithm
for i=1:4
    % preprocess the images
    filename = ['StopSign',num2str(i),'.jpg'];
    StopSigns{i} = double(imread(fullfile("..",dirname,filename)))/255;
    gray = rgb2gray(StopSigns{i});
    % find frames and descriptors
    [frames{i},descriptors{i}] = sift(gray);
    descriptors{i} = uint8(512*descriptors{i});
    % find affine transform for first image with the others images
    if(i > 1)
        % find matches
        matches = siftmatch(descriptors{1}, descriptors{i});
        if (i == 2)
            figure
            plotmatches(StopSigns{1},StopSigns{i},frames{1}(1:2,:),frames{i}(1:2,:),matches);
        end
        % find affine transform with RANSAC algorithm
        p_s = [ frames{1}(1,matches(1,:)) ; frames{1}(2,matches(1,:)) ] ; % first image key points
        p_d = [ frames{i}(1,matches(2,:)) ; frames{i}(2,matches(2,:)) ] ; % i image key points
        [H{i-1}, p1]  = RANSAC(p_s, p_d);
        % plot RANSAC projected key points
        numPts = length(p1(1,:));
        p2 = H{i-1} * [p1; ones(1,numPts)]; % RANSAC projected key points
        p2 = p2(1:2,:);
        RGB1 = insertMarker(StopSigns{1},p_s');
        RGB2 = insertMarker(StopSigns{i},p2');
        if (i == 2)
            figure
            subplot(1,2,1)
            imshow(RGB1);
            subplot(1,2,2)
            imshow(RGB2);
        end
        % show first image projected
        projI = imageWarping(StopSigns{1},H{i-1});
        if (i == 2)
            figure
            imshow(projI)
        end
        % show stitched image
        stitchI = templateStitching(StopSigns{i},projI);
        figure
        montage({StopSigns{i},stitchI});
    end
end