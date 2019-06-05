function [] = HW3Q1()

%% Task A
clc; close all; clear all;
N = 16;
t = 0.1;

url = fullfile('seq.gif');

[images, cmap] = imread(url, 'Frames', 'all');
[Width, Height, C, count] = size(images);

previous = zeros(Width, Height);

% test
opticFlow = opticalFlowLK('NoiseThreshold',0.015);
h = figure(3);
movegui(h);
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
hPlot = axes(hViewPanel);

for k=1:count
    current = images(:,:,:, k);
    if k == 1
        previous = current;
        % test matlab implementation
        flow = estimateFlow(opticFlow,current);
        continue;
    end
    [ X,Y,U,V ] = opticalFlow2(previous, current, N, t);
    
    previous = current;
    
    flow = estimateFlow(opticFlow,current);
    imshow(current)
    axis image
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10,'Parent',hPlot);
    hold off
    
%     figure();
%     imshow(current);
%     hold on;
%     % draw the velocity vectors
%     quiver(Y,X,V,U, 'b');
%     title(['Optical Flow:','Locus Kanade']);
%     xlabel(['N = ', num2str(N), ', dt = ', num2str(t)]);
end
    