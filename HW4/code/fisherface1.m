function [meanvec, basis] = fisherface(face_data, label_train, c)

% tutorial #1 https://www.bytefish.de/pdf/facerec_octave.pdf
% github   #2 https://github.com/Naman-ntc/FaceRecognition/tree/master/FisherFaces
% moreinfo #3 http://www.csd.uwo.ca/~olga/Courses/CS434a_541a/Lecture8.pdf

% FISHERFACE Creates the Fisher face basis for a set of images
%
% face_data - cell array containing the face images
% label_train - the training labels matching c classes
% c - number of classes to use
%
% meanvec - mean vector of the face images
% basis - Fisher basis of the face images
%

% Use Principle Component Analysis (PCA) and Fisher Linear Discriminant (FLD) to determine the most 
% discriminating features between images of faces.
%
% Description: This function gets a 2D matrix, containing all training image vectors
% and returns 4 outputs which are extracted from training database.
% Suppose Ti is a training image, which has been reshaped into a 1D vector.
% Also, P is the total number of MxN training images and C is the number of
% classes. At first, centered Ti is mapped onto a (P-C) linear subspace by W_PCA
% transfer matrix: Zi = W_PCA * (Ti - m_database).
% Then, Zi is converted to Yi by projecting onto a (C-1) linear subspace, so that 
% images of the same class (or person) move closer together and images of difference 
% classes move further apart: Yi = V_Fisher' * Zi = V_Fisher' * W_PCA' * (Ti - m_database)
%
% Argument:      T                      - (M*NxP) A 2D matrix, containing all 1D image vectors.
%                                         All of 1D column vectors have the same length of M*N 
%                                         and 'T' will be a MNxP 2D matrix.
% 
% Returns:       m_database             - (M*Nx1) Mean of the training database
%                W_PCA                  - (M*Nx(P-C)) Eigen vectors of the covariance matrix of the 
%                                         training database
%                V_Fisher               - ((P-C)x(C-1)) Largest (C-1) eigen vectors of matrix J = inv(Sw) * Sb
%                ProjectedImages_Fisher - ((C-1)xP) Training images, which are projected onto Fisher linear space
%
Class_number = c; % Number of classes (or persons)
Class_population = size(face_data, 2) / c; % Number of images in each class
P = Class_population * Class_number; % Total number of training images
%%%%%%%%%%%%%%%%%%%%%%%% calculating the mean image 
mean_face = mean(face_data,2); 
%%%%%%%%%%%%%%%%%%%%%%%% Calculating the deviation of each image from mean image
A = face_data - repmat(mean_face,1,P);
%%%%%%%%%%%%%%%%%%%%%%%% Snapshot method of Eigenface algorithm
L = A'*A; % L is the surrogate of covariance matrix C=A*A'.
[V, ~] = eig(L); % Diagonal elements of D are the eigenvalues for both L=A'*A and C=A*A'.
%%%%%%%%%%%%%%%%%%%%%%%% Sorting and eliminating small eigenvalues
L_eig_vec = V(:,1:P-Class_number);
%%%%%%%%%%%%%%%%%%%%%%%% Calculating the eigenvectors of covariance matrix 'C'
W_PCA = A * L_eig_vec; % A: centered image vectors
%%%%%%%%%%%%%%%%%%%%%%%% Projecting centered image vectors onto eigenspace
% Zi = W_PCA' * (Ti-m_database)
ProjectedImages_PCA = [];
for i = 1 : P
    temp = W_PCA'*A(:,i);
    ProjectedImages_PCA = [ProjectedImages_PCA temp]; 
end
%%%%%%%%%%%%%%%%%%%%%%%% Calculating the mean of each class in eigenspace
m_PCA = mean(ProjectedImages_PCA,2);       % Total mean in eigenspace
m = zeros(P-Class_number,Class_number);    % Mean vector of the face images
Sw = zeros(P-Class_number,P-Class_number); % Initialization os Within Scatter Matrix
Sb = zeros(P-Class_number,P-Class_number); % Initialization of Between Scatter Matrix
for i = 1 : Class_number
    m(:,i) = mean( ( ProjectedImages_PCA(:,((i-1)*Class_population+1):i*Class_population) ), 2 )';    
    
    Sk  = zeros(P-Class_number,P-Class_number); 
    for j = ( (i-1)*Class_population+1 ) : ( i*Class_population )
        Sk = Sk + (ProjectedImages_PCA(:,j)-m(:,i))*(ProjectedImages_PCA(:,j)-m(:,i))';
    end
    
    Sw = Sw + Sk; % Within Scatter Matrix
    Sb = Sb + (m(:,i)-m_PCA) * (m(:,i)-m_PCA)'; % Between Scatter Matrix
end
%%%%%%%%%%%%%%%%%%%%%%%% Calculating Fisher discriminant basis's
% We want to maximise the Between Scatter Matrix, while minimising the
% Within Scatter Matrix. Thus, a cost function J is defined, so that this condition is satisfied.
[J_eig_vec, ~] = eig(Sb,Sw); % Cost function J = inv(Sw) * Sb
J_eig_vec = fliplr(J_eig_vec);
%%%%%%%%%%%%%%%%%%%%%%%% Eliminating zero eigens and sorting in descend order
for i = 1 : Class_number-1 
    V_Fisher(:,i) = J_eig_vec(:,i); % Largest (C-1) eigen vectors of matrix J
end
%%%%%%%%%%%%%%%%%%%%%%%% Projecting images onto Fisher linear space
% Yi = V_Fisher' * W_PCA' * (Ti - m_database) 
for i = 1 : Class_number*Class_population
    ProjectedImages_Fisher(:,i) = V_Fisher' * ProjectedImages_PCA(:,i);
end

basis = ProjectedImages_Fisher;
meanvec = m;
