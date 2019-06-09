function [] = HW3Q1()

%% Task A
clc; close all; clear all;
N = 16;
t = 0;

url = fullfile('seq.gif');

[images, ~] = imread(url, 'Frames', 'all');
[Width, Height, ~, count] = size(images);

previous = zeros(Width, Height);

for k=1:count
    current = images(:,:,:, k);
    if k == 1
        previous = current;
        continue;
    end
    [ X,Y,U,V ] = estimateFlowLK(previous, current, N, t);
    
    previous = current;
    
    figure(k);
    imshow(current);
    hold on;
    quiver(Y,X,U,V,'r');
    title(['Optical Flow:','Locus Kanade']);
    xlabel(['Frame ', num2str(k),' N = ', num2str(N), ', dt = ', num2str(t)]);
end
    