function [ X,Y,U,V ] = estimateFlowLK(I1, I2, N, t)
 % I1 - The current frame.
 % I2 - The next frame.
 % N  - The region size N x N.
 % t  - The threshold of for the minimum eigenvalue of AᵀA.
 
im1 = im2double(I1);
im2 = im2double(I2);

% for each point, calculate Iₓ, Iᵧ, I_t
[Ix_m, Iy_m] = gradient(im1);
It_m = im2 - im1;

sz = size(im1);
flow_size = floor(sz ./ N);

U = zeros(flow_size);
V = zeros(flow_size);
X = zeros(flow_size);
Y = zeros(flow_size);

w = round(N/2);

% Estimate flow within region of N x N
for i = 1:flow_size(1)
    i1 = (i - 1) * N + 1;
    i2 = min(i1 + N,sz(1));
    
   for j = 1:flow_size(2)
      j1 = (j - 1) * N + 1;
      j2 = min(j1 + N,sz(2)); 
      Ix = Ix_m(i1:i2, j1:j2);
      Iy = Iy_m(i1:i2, j1:j2);
      It = It_m(i1:i2, j1:j2);

      b = -It(:);  % b
      A = [Ix(:) Iy(:)]; % A
      
      % obtain the smallest eignevalue of of AᵀA
      A2 = A' * A;
      d = eigs(A2, 1, 'SR');
      if d < t
          continue;
      end
      
      % Calculate directional velocity u = (AᵀA)⁻¹Ab
      nu = pinv(A2) * (A' * b); 

      U(i,j) = nu(1);
      V(i,j) = nu(2);
      X(i,j) = i1 + w;
      Y(i,j) = j1 + w;
   end
end

end