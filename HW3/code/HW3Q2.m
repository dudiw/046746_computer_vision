function [] = HW3Q2()

clc; close all; clear all;

info = inl1();

% clear NaN in pts2d - meaning 3d points that exceed the image bounds
[~, cols] = find(isnan(info.pts2d) == 1);
info.pts2d(:,cols(:)) = [];
info.pts3d(:,cols(:)) = [];

% Section A
% Calculate the projection according to the corresponding 3d → 2d points
P = solveDLT(info.pts3d, info.pts2d);

% Section B
% Reproject the 3d (real world) points onto the image plane and apply MSE.
X = info.pts3d;
x = info.pts2d;
x_hat = P * X;

% normalize the projected points (homogeneous coordinates)
xh_hat = x_hat(1:2,:) ./ x_hat(3,:);
xh     = x(1:2,:)     ./ x(3,:);
% error measured in pixels
err = immse(xh, xh_hat);
fprintf('error %f \n', err);

% Section C
% Reconstruct R and K
% *** !!! *** ====================
% C.1) Describe the goal of this function. What is the difference between 
%      the given function and the matlab function called “qr.m”? 
%      Why didn’t we use the qr function? 
% C.2) Explain the operation done at each of the function lines.
KR    = P(:,1:3);
[R,~] = rq(KR);

% K = KR * R⁻¹ = KR * Rᵀ
K = KR * R';

% Section d 
% *** !!! *** ====================
% What can you say about the camera characters, from the matrix K ? 
% Are the intrinsic camera parameters reasonable?

% Section e 
% *** !!! *** ====================
% What can you say about the orientation of the camera from the matrix R ? 
% Is that reasonable?

% Section f
% Calculate the translation vector t (in the rotated camera space).
% P =  [KR | Kt] → T = Kt
% t =  K⁻¹ * T
% c = -R⁻¹ * t = -Rᵀ * t

T = P(:,4);
t = K\T; 
c = -R' * t;

% Section g
% Plot the camera location onto the given 3D field model.
figure(2);
plot3(c(1),c(2),c(3),'-<');

% Section h
% Using all the above information, can you determine if the ball actually 
% crossed the goal line? If yes, give an explanation and calculation. 
% If not, explain why.
x_ball = [1599 680 1]';
X_ball = x_ball\P;
plot3(X_ball(1),X_ball(2),X_ball(3),'-s');



