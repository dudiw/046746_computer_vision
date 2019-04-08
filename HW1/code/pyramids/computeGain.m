function [ gain ] = computeGain( layer_input,layer_example,sigma )
% 
% function [ gain ] = computeGain( ayer_input,layer_example,sigma ) 
% 
% Function   : computeGain
% 
% Purpose    : Computes the gain map for each pyramid level.
% 
% Parameters : layer_input   - The layer of the input image.
%              layer_example - The layer of the example image.
%              sigma         - The filter sigma.
%
% Return     : gain          - The gain map.
%

epsilon = 1e-4;
gain_max = 2.8;
gain_min = 0.9;

filter = fspecial('gaussian', sigma*5, sigma);

% Local energy for input and example layers.
energy_input = imfilter(layer_input.^2, filter);
energy_example = imfilter(layer_example.^2, filter);

% Gain map from local energy.
gain = (energy_example./(energy_input + epsilon)).^0.5;

% Clip level gain to [gain_min gain_max]
gain(gain>gain_max)=gain_max;
gain(gain<gain_min)=gain_min;