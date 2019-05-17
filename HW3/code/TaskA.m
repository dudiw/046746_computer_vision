%% Task A
clc; close all; clear all;
N = 16;
t = 0.1;

url = fullfile('..','seq.gif');

[images, cmap] = imread(url, 'Frames', 'all');
[Width, Height, C, count] = size(images);

previous = zeros(Width, Height);

for k=1:count
    current = images(:,:,:, k);
    if k == 1
        previous = current;
        continue;
    end
    [ X,Y,U,V ] = opticalFlow(previous, current, N, t);
    
    previous = current;
    
    figure();
    imshow(current);
    hold on;
    % draw the velocity vectors
    quiver(X,Y,U,V, 'y');
    title(['Optical Flow:','Locus Kanade']);
    xlabel(['N = ', num2str(N), ', dt = ', num2str(t)]);
end