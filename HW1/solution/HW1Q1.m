% Task 1 - transform
clear all;
clc;

N = 101;
M = ceil(101 / 2);
f=zeros(N,N);

values = [[1,1],[N,1],[1,N],[N,N],[M,M]];

figure;
index = 1;
last = numel(values) - 1;

for k = 1:2:last
    x = values(k);
    y = values(k + 1);
    f(x,y)=1;
    H=hough(f);
    subplot(1,5,index);
    imshow(H,[])
    title(num2str(index));
    index = index + 1;
end    

%% Task 1 - Canny edge detector
clear all;
close all;
clc;

addpath('hough');

N = 256;
square_start = N / 4;
square_end = square_start + N / 2;
I = zeros(N);
I(square_start:square_end, square_start:square_end) = 1;

houghOverlay('Square: Bitmap',I);

%% Task 1 - Line linking on building.jpg
clear all;
close all;
clc;

addpath('hough');

I = imread('building.jpg');
houghOverlay('Building.jpg',I);