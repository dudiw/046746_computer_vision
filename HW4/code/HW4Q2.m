function [] = HW4Q2()
clc; close all;


% == Section 1 - Fisher space   == %

cd(fullfile('eigenFaces'));
readYaleFaces;               % load train set (1.a)
cd(fullfile('..'));

C = 15;
[meanvec, basis] = fisherface(A, train_face_id, C);


% == Section 2 - Reconstruction == %

% Train set: Reconstruction
Y = basis' * (A - meanvec);        % project to fisher space
X = basis  *  Y + meanvec;         % reconstruct
X(X > 255) = 255;
X(X < 0)   = 0;

% Representation metrics
Norm = @(M)   M / diag(max(M) - min(M));
RMSE = @(S,T) sum(sqrt(sum((S - T).^ 2) ./ size(S,1)) ./ size(S,2));
DRE  = @(S,T) RMSE(Norm(S), Norm(T));

% Train set: Representation error
Train.RMSE = RMSE(A,X) ./ 255 * 100;  % Train RMSE
Train.DRE  = DRE(A,X) * 100;          % Train DRE
Train.data = 'Train set';
Train.task = 'Reconstruction';

% Test set
indices = find(face_id > 0);
labels  = face_id(indices);
B = zeros(m * n, length(indices));
j = 1;
for i = indices
    name = "image" + num2str(i);
    image  = double(eval(name));
    B(:,j) = image(:);
    j = j + 1;
end

% Test set: Reconstruction
Yt = basis' * (B - meanvec);        % project to fisher space
X  = basis  *  Yt + meanvec;        % reconstruct
X(X > 255) = 255;
X(X < 0)   = 0;

Test.RMSE = RMSE(B,X) ./ 255 * 100; % Test RMSE
Test.DRE  = DRE(B,X) * 100;         % Test DRE
Test.data = 'Test set';
Test.task = 'Reconstruction';

% Print results
formatted = 'Fisherface %9s %s\t%8s: %3.1f%%\n';
fprintf(formatted, Train.data, Train.task, 'RMSE', Train.RMSE);
fprintf(formatted, Train.data, Train.task, 'DRE',  Train.DRE);

fprintf(formatted, Test.data, Test.task, 'RMSE', Test.RMSE);
fprintf(formatted, Test.data, Test.task, 'DRE',  Test.DRE);


% == Section 3 - Classification error == %

% Classification model and metric
model_knn = fitcknn(Y',train_face_id); % K-NN model

% Test set: Classification error
results = model_knn.predict(Yt');     % classify test images

Test.accuracy = mean(results' == labels) * 100;
Test.task     = 'Recognition';

% Print results
fprintf(formatted, Test.data, Test.task, 'Accuracy', Test.accuracy);

end