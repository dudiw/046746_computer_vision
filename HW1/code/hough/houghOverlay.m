function [ ] = houghOverlay( fig_title,I,varargin )
% 
% function [ ] = houghOverlay( image,title ) 
% 
% Function   : houghOverlay
% 
% Purpose    : Overlays Hough-Lines obtained from Canny edges.
% 
% Parameters : fig_title  - The title.
%              I          - The input image.
%              threshold  - Sensitivity threshold, as a numeric scalar
%                           or a 2-element vector. 
%                           Ignores all edges that below than threshold. 
%                           Set an empty array ([]) to automatically 
%                           choose the appropriate values automatically.
%              sigma      - Standard deviation of the Gaussian filter, 
%                           as a scalar. The default is sqrt(2)
%

defaultThreshold = [];
defaultSigma = sqrt(2);

p = inputParser;
addRequired(p,'fig_title',@ischar);
addRequired(p,'I');
addOptional(p,'threshold', defaultThreshold);
addOptional(p,'sigma',defaultSigma);
parse(p,fig_title,I,varargin{:});
   
threshold = p.Results.threshold; 
sigma = p.Results.sigma;
fig_title = convertCharsToStrings(p.Results.fig_title);

if (isempty(threshold))
    edges = edge(I,'Canny');
else
    edges = edge(I,'Canny',threshold,sigma);
end    

[H,T,R] = hough(edges);

figure;
subplot(1,2,1);
imshow(I,[]);
title(fig_title);

subplot(1,2,2);
imshow(edges,[]);
title([fig_title, ' - Canny Edges']);

figure;
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;
title([fig_title, ' - Hough Transform', 'on Canny Edges']);

% Task 1 - Voting
figure;
P  = houghpeaks(H,4);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(T(P(:,2)),R(P(:,1)),'s','color','white');
title([fig_title, ' - Hough Peaks', 'on Canny Edges']);

pause(0.3); % pause to avoid figure override

% Task 1 - Line linking
lines = houghlines(edges,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(I), hold on
title([fig_title, ' - Hough Lines', 'overlay on image']);
for k = 1:numel(lines)
	xy = [lines(k).point1; lines(k).point2];
	plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end

