function [] = HW1Q2()
% Task 2 - Laplacian pyramid for style transfer

addpath('pyramids');

clear all;
% close all;
clc;

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

% Task 2 (b) - Pyramid Reconstruction
image = reconstructImage(pyramids);
figure;
imshow(image,[]);
title(['Reconstructed: Image ' ,image_name]);

example_name = '6';
path_E_bg = fullfile(path_background, strcat(example_name,'.jpg'));

% Task 2 (c) - Background
mask = im2double(imread(path_I_mask));
background = im2double(imread(path_E_bg));
image = maskBackground(image, mask, background);
figure;
imshow(image,[]);
title(['Background transfer: Image ' ,image_name]);

%% Task 2 (d,e,f,g) - Energy, gain map and image reconstruction

addpath('pyramids');

% Output directory
mkdir('output')

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
    output_name = strcat('image_', image_name, '_example_', example_name);
    output_path = fullfile('output', output_name);
    print(output_path,'-dpng')
end
