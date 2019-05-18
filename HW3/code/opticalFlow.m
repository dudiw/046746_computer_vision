function [ X,Y,U,V ] = opticalFlow(I1, I2, N, t)
 % I1:  The current frame.
 % I2:  The next frame.
 % N:   The region size N x N.
 % t:   The threshold of for the minimum aigenvalue of AᵀA.
 
im1 = im2double(I1);
im2 = im2double(I2);
 
% for each point, calculate Iₓ, Iᵧ, I_t
Ix_m = conv2(im1,[-1 1; -1 1], 'valid'); % partial on x
Iy_m = conv2(im1, [-1 -1; 1 1], 'valid'); % partial on y
It_m = conv2(im1, ones(2), 'valid') + conv2(im2, -ones(2), 'valid'); % partial on t

% [Ix_m, Iy_m] = gradient(im1);
% It_m = im2 - im1;
u = zeros(size(im1));
v = zeros(size(im2));

w = round(N/2);

% Estimate flow within region of N x N
for i = w+1:size(Ix_m,1)-w
   for j = w+1:size(Ix_m,2)-w
      Ix = Ix_m(i-w:i+w, j-w:j+w);
      Iy = Iy_m(i-w:i+w, j-w:j+w);
      It = It_m(i-w:i+w, j-w:j+w);

      Ix = Ix(:);
      Iy = Iy(:);
      b = -It(:);  % b
      A = [Ix Iy]; % A
      
      % obtain the smallest eignevalue of of AᵀA
      A2 = A' * A;
      d = eigs(A2, 1, 'SR');
      if d < t
          continue;
      end
      
      % Calculate directional velocity u = (AᵀA)⁻¹Ab
      
      % nu = (A' * b) \ A2; 
      nu = pinv(A)*b; 

      u(i,j)=nu(1);
      v(i,j)=nu(2);
   end
end

% downsize u and v
U = u(1:10:end, 1:10:end);
V = v(1:10:end, 1:10:end);
% get coordinate for u and v in the original frame
[m, n] = size(im1);
[X,Y] = meshgrid(1:n, 1:m);
X = X(1:20:end, 1:20:end);
Y = Y(1:20:end, 1:20:end);

end