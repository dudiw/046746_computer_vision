function [eigens] = eigenVectorsCov(A, r)
%
% function [eigens] = eigenVectorsCov(A, r)
%
% Function   : eigenVectorsCov
%
% Purpose    : find r largest eigen-vectors of the covariance matrix AA'
%
% Parameters : A          -  input matrix.
%              r          -  number of eigen vectors.
%
% Return     : eigens     - matrix of column vectors of r largest eigen 
%                           vectors.

%% eigens of A'A
% A_t much more smaller matrix for calculation;
A_t = A'*A;

% U_t is a matrix of the eigen vectors of A'A
[V_t,~] = eig(A_t);
e_t = eig(A_t);
[~,I] = sort(e_t,'descend');

U_t = V_t(:,I);

% U is a matrix of the normalized eigen vectors of AA'
U = normalize(A*U_t,'norm',2);

%% equal to svd 'econ'
% % U - the left singular vectors of A, is a matrix of the eigen vectors of
% % AA'
%  [U,~,~] = svd(A,'econ');

%%
% take the largest r
eigens = U(:,1:r);

end