function A = solveDLT(x,y)
% x - 3d points
% y - 2d points

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
[~,~,V] = svd(A');

% the eigenvector of the smallest eigenvalue minimizes A
v_min = V(:,end);
A = reshape(v_min,m,n);
% normalize A
A = A / norm(A) * sign(A(1,1));