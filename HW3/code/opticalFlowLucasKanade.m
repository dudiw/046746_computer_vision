function [ X,Y,U,V ] = opticalFlowLucasKanade(I1, I2, N, t)
 % I1:  The current frame.
 % I2:  The next frame.
 % N:   The region size N x N.
 % t:   The threshold of for the minimum aigenvalue of AᵀA.
 
% guide 0 https://www.mathworks.com/matlabcentral/fileexchange/48744-lucas-kanade-tutorial-example-1 
% guide 1 http://www.cs.ucf.edu/~mikel/Research/Optical_Flow.htm
% guide 2 http://www.numerical-tours.com/matlab/multidim_5_opticalflow/

% Matlab full https://www.mathworks.com/matlabcentral/fileexchange/49012-optical-flow-algorithm  
 
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
for i = w+1:w:size(Ix_m,1)-w
   for j = w+1:w:size(Ix_m,2)-w
      Ix = Ix_m(i-w:i+w-1, j-w:j+w-1);
      Iy = Iy_m(i-w:i+w-1, j-w:j+w-1);
      It = It_m(i-w:i+w-1, j-w:j+w-1);

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
U = u(1:N:end, 1:N:end);
V = v(1:N:end, 1:N:end);
% get coordinate for u and v in the original frame
[m, n] = size(im1);
[X,Y] = meshgrid(1:n, 1:m);
X = X(1:N:end, 1:N:end);
Y = Y(1:N:end, 1:N:end);

end