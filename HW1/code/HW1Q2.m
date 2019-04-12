function [] = HW1Q2()
% Task 2 - Laplacian pyramid for style transfer

addpath('pyramids');

% Inputs
path_inputs = fullfile('data', 'Inputs', 'imgs');
path_masks  = fullfile('data', 'Inputs', 'masks');

% Examples
path_examples = fullfile('data', 'Examples', 'imgs');
path_background = fullfile('data', 'Examples','bgs');

% Input image
image_name = '0004_6';
path_I = fullfile(path_inputs, strcat(image_name,'.png'));
path_I_mask = fullfile(path_masks, strcat(image_name,'.png'));

% Image decomposition into Laplacian Pyramid and image reconstruction
I = im2double(imread(path_I));
I = rgb2gray(I);

nLevel = 6;

% Task 2 (a) - Laplacian Pyramids
pyramids = laplacianPyramids(I, nLevel);
figure;
index = 1;

subplot(3,3,[1,2,3]);
imshow(I,[])
title(['Original: Image ' ,image_name]);
for k = 1:nLevel
    pyramid = pyramids{k};
    subplot(3,3,3 + index);
    imshow(pyramid,[])
    title(['Pyramid l=',num2str(index)]);
    index = index + 1;
end  

% Save results
output_name = strcat('img_', image_name, '_laplacian_pyramids');
output_path = fullfile('output', output_name);
print(output_path,'-dpng')

% Task 2 (b) - Pyramid Reconstruction
image = reconstructImage(pyramids);
figure;
subplot(1,2,1);
imshow(I,[]);
title(['Orginal: Image ' ,image_name]);
subplot(1,2,2);
imshow(image,[]);
title(['Reconstructed: Image ' ,image_name]);

% Save results
output_name = strcat('img_', image_name, '_pyramid_reconstruction');
output_path = fullfile('output', output_name);
print(output_path,'-dpng')

example_name = '6';
path_E_bg = fullfile(path_background, strcat(example_name,'.jpg'));

% Task 2 (c) - Background
I = im2double(imread(path_I));
figure;
subplot(1,2,1);
imshow(I,[]);
title(['Orginal: Image ' ,image_name]);
mask = im2double(imread(path_I_mask));
background = im2double(imread(path_E_bg));
image = maskBackground(I, mask, background);
subplot(1,2,2);
imshow(image,[]);
title(['Background transfer: Image ' ,image_name]);

% Save results
output_name = strcat('img_', image_name, '_bg_transfer');
output_path = fullfile('output', output_name);
print(output_path,'-dpng')

%% Task 2 (d,e,f,g) - Energy, gain map and image reconstruction

addpath('pyramids');

% Inputs
path_inputs = fullfile('data', 'Inputs', 'imgs');
path_masks  = fullfile('data', 'Inputs', 'masks');

% Examples
path_examples = fullfile('data', 'Examples', 'imgs');
path_background = fullfile('data', 'Examples','bgs');

% Output directory
output_path = strcat('output_',datestr(now,'mmmm-dd-yy_HH:MM'));
mkdir(output_path)

inputs = {'0004_6','6';'0004_6','16';'0004_6','21'; ...
    '0006_001','0';'0006_001','9';'0006_001','10'};

for k=1:length(inputs)
    [image_name, example_name] = inputs{k,:};
    
    % Input image
    path_I = fullfile(path_inputs, strcat(image_name,'.png'));
    path_I_mask = fullfile(path_masks, strcat(image_name,'.png'));

    % Example image
    path_E = fullfile(path_examples, strcat(example_name,'.png'));
    path_E_bg = fullfile(path_background, strcat(example_name,'.jpg'));

    % Load images
    I          = im2double(imread(path_I));
    example    = im2double(imread(path_E));
    mask       = im2double(imread(path_I_mask));
    background = im2double(imread(path_E_bg));
    
    % Style transfer
    nLevel = 6;
    output = transferStyle(I, nLevel, example, background, mask);

    figure;
    subplot(1,3,1);
    imshow(I,[]);
    title(['Original: Image ' ,image_name]);
    subplot(1,3,2);
    imshow(example,[]);
    title(['Example: Image ' ,example_name]);
    subplot(1,3,3);
    imshow(output,[]);
    title(['Stylized: Image ' ,image_name]);
    
    % Save results
    output_name = strcat('img_', image_name, '_ex_', example_name);
    result = fullfile(output_path, output_name);
    print(result,'-dpng')
end

%% Task 2 (h) - Energy, gain map and image reconstruction for out of data example
close all;
clear all;
clc;

addpath('pyramids');

% Load images
custom = 'Custom';
path = fullfile('data', custom);
I          = im2double(imread(fullfile(path, 'input.png')));
mask       = im2double(imread(fullfile(path, 'mask.png')));
example    = im2double(imread(fullfile(path, 'target.png')));
background = im2double(imread(fullfile(path, 'background.jpg')));

% Preprocess the mask and background
mask = rgb2gray(mask);
mask(mask>0)=1.0;
[M,N,~] = size(I);
background = imresize(background, [M N]);

% Style transfer
nLevel = 6;
output = transferStyle(I, nLevel, example, background, mask);

figure;
subplot(1,3,1);
imshow(I,[]);
title(['Original: Image ' ,custom]);
subplot(1,3,2);
imshow(example,[]);
title(['Example: Image ' ,custom]);
subplot(1,3,3);
imshow(output,[]);
title(['Stylized: Image ' ,custom]);

% Save results
output_name = strcat('img_', custom, '_ex_', custom);
output_path = fullfile('output', output_name);
print(output_path,'-dpng')
