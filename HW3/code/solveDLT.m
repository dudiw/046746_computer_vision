function A = solveDLT(x,y)
% A = solveDLT(x,y) solves for the projective transformation matrix A with respect to
% the linear system y ~ Ax where ~ denotes equality up to a scale, using the
% Direct Linear Transformation technique. A is a m-by-n matrix, x is a n-by-k
% matrix that contains k source points in column vector form and y is a m-by-k
% matrix containning k target points in column vector form. The solution is
% normalised as any multiple of A also satisfies the equation.

[n,k] = size(x);
[m,~] = size(y);

% transform to inhomogeneous coordinates
r = 1:m-1;
y = y(r,:)./y(m,:);

% concatinate point-pairs towards a homogeneous linear system
A = zeros(m,n,k,m-1);
for i = r
    b = -x .* y(i,:);
    A(i,:,:,i) = reshape(x,1,n,k);
    A(m,:,:,i) = reshape(b,1,n,k);
end
% flatten A
A = reshape(A,m*n,[]);
% solve using SVD
[~,~,V] = svd(A*A');

% the singular vector of the smallest singular value minimizes |A'A|
v_min = V(:,end);
A = reshape(v_min,m,n);
% normalize A
A = A / norm(A) * sign(A(1,1));