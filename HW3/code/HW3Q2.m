function [] = HW3Q2()

% HW3.Q2: Camera Calibration

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
x_projected = P * X;

% normalize the projected points (homogeneous coordinates)
xh_projected = x_projected(1:2,:) ./ x_projected(3,:);
xh = x(1:2,:) ./ x(3,:);

% mean error of the euclidian distance between the 
% projected points and the ground truth points, in pixels.
error = mean(sqrt(sum((xh - xh_projected) .^ 2)));
fprintf('error %f \n', error);

% Section C
% Reconstruct R and K using RQ decomposition
KR    = P(:,1:3);
[K,R] = rq(KR);

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
% Using all the above information, and the center ball pixel x_ball, 
% determine whether the ball crossed the goal line.
x_ball = [1599 680 1]';
X_ball = x_ball\P;
X_ball = X_ball ./ X_ball(4);
plot3(X_ball(1),X_ball(2),X_ball(3),'-s');



