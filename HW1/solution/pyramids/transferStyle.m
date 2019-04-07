function [ output ] = transferStyle( input,nLevel,example,background,mask )
% 
% function [ output ] = transferStyle( image,title ) 
% 
% Function   : transferStyle
% 
% Purpose    : Transfers the style of the example image to the input image.
% 
% Parameters : input      - The input image.
%              nLevel     - The number of pyramid levels.
%              example    - The example style image to be transfered.
%              background - The stylized background to be transfered.
%              mask       - The binary mask used for background segmentation.
%
% Return     : output     - The input image stylized as the example image.
%

% Replace the input image background using the example background.
input = maskBackground(input, mask, background);

[M,N,channels] = size(input);
output = zeros(M,N,channels);

% Iterate over R,G,B channels
for c = 1:channels
    
    % Decompose Laplacian Pyramids of the input and example images.
    pyramid_input   = laplacianPyramids(input(:,:,c), nLevel);
    pyramid_example = laplacianPyramids(example(:,:,c), nLevel);

    pyramid_output = pyramid_input;

    for i = 1 : nLevel-1
        layer_example = pyramid_example{i};
        layer_input   = pyramid_input{i};        
        
        sigma = 2*2^(i+1);
        gain = computeGain(layer_input, layer_example, sigma);

        % Apply layer gain to input layer.
        pyramid_output{i} = layer_input .* gain; 
    end
    output(:,:,c) = reconstructImage(pyramid_output);
end

% Replace the output image background using the example background. 
output = maskBackground(output, mask, background);