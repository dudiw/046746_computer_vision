function [meanvec, basis] = fisherface(face_data, label_train, c)
% face_data   - cell array containing the face images
% label_train - the training labels matching c classes
% c           - number of classes to use
%
% meanvec     - mean vector of the face images
% basis       - Fisher basis of the face images

X = face_data;
y = label_train;
N = size(X,2);
r = N - c;

meanvec = mean(X,2);              % mean vector of the face pixels

% PCA
mu = meanvec;                     % mean of X
Xm = X - mu;                      % zero center
[U,~,~] = svd(Xm,'econ');         % svd on centered data
Wpca = U(:,1:r);                  % keep r = (N - c) components

X = Wpca' * Xm;                   % project data 

% LDA
mu = mean(X,2);                   % total mean of X
Sw = zeros(r,r);                  % within-class scatter
Sb = zeros(r,r);                  % between-class scatter

% calculate scatter matrices
for i = 1:length(unique(y))
    Xi = X(:,y == i);             % samples for current class
    n = size(Xi,2);
    mu_i = mean(Xi,2);            % mean vector for current class
    Xi = Xi - mu_i;
    Sw = Sw + Xi * Xi';
    Sb = Sb + n * (mu_i - mu) * (mu_i - mu)';
end

[Wlda,D] = eig(Sb, Sw);           % solve general eigenvalue problem
[~,i] = sort(diag(D),'descend');  % sort eigenvectors
Wlda  = Wlda(:, i);
Wlda  = Wlda(:, 1:(c - 1));       % keep (c - 1) eigenvectors

basis = Wpca * Wlda;              % Fisher basis
basis = normc(basis);
end