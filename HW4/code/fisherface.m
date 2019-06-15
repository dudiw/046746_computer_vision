function [meanvec, basis] = fisherface(face_data, label_train, c)
% face_data   - cell array containing the face images
% label_train - the training labels matching c classes
% c           - number of classes to use
%
% meanvec     - mean vector of the face images
% basis       - Fisher basis of the face images

N = rows(face_data);                % number of samples
c = length(label_train);            % number of classes

% get (N - c) principal components
[n , d] = size(X);
mu = mean(X);                       % mean of X
Xm = X - repmat(mu, rows(X), 1);    % zero center
C = Xm * Xm';                       % covariance of X
[Wpca , D] = eig(C) ;
Wpca = Xm' * Wpca ;                 % multiply with data matrix

% normalize eigenvectors
for i = 1:n
    Wpca(:, i) = Wpca(:, i) / norm(Wpca(:, i));
end


[~, i] = sort(diag(D) , 'descend'); % sort eigenvalues and eigenvectors
Wpca = Wpca(: , i);
Wpca = Wpca(: ,1:(N - c));          % keep (N - c) components


X = X - repmat(mu, rows(X), 1) * W; % project

% LDA
meanvec = mean(X);                  % total mean of X
Sw = zeros(d, d);                   % within-class scatter
Sb = zeros(d, d);                   % between-class scatter

% calculate scatter matrices
for i = 1:length(label_train)
    Xi = X(find(y == label_train(i)), :) ; % samples for current class
    n = rows(Xi);
    mu_i = mean(Xi);                % mean vector for current class
    Xi = Xi - repmat (mu_i, n, 1) ;
    Sw = Sw + Xi' * Xi ;
    Sb = Sb + n * (mu_i - meanvec)' * (mu_i - meanvec);
end

[Wlda, D] = eig(Sb, Sw );           % solve general eigenvalue problem
[~ , i] = sort(diag(D), 'descend'); % sort eigenvectors
Wlda = Wlda(:, i);
Wlda = Wlda(: ,1: k);               % keep (c - 1) eigenvectors

basis = Wpca * Wlda;                % Fisher basis
end