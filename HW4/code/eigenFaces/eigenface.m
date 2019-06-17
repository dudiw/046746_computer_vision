
% load train set (1.a)
readYaleFaces;

% A - is the training set matrix where each column is a face image
% train_face_id - an array with the id of the faces of the training set.
% image1--image20 are the test set.
% is_face - is an array with 1 for test images that contain a face
% faec_id - is an array with the id of the face in the test set,
%           0 if no face and -1 if a face not from the train-set.

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Your Code Here  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trainset_num = length(train_face_id);
testset_num = 20;
image_len = length(A(:,1));

%% Subtract mean image (1.b)

% (Each column of A corresponds to a distinct image)
mean_image = mean(A,2);
A_meaned = A - mean_image;

%% Compute eigenvectors and report first 5 eigen-faces (2)

num_eigens = 5;
% 5 biggest eigen faces
U_AA = eigenVectorsCov(A_meaned,num_eigens);

% Show eigen faces:
figure()
for i=1:num_eigens
    subplot(2,3,i)
    imshow(reshape(U_AA(:,i),size(image1)),[]);
    title("eigen face " + num2str(i));
end

%% Display and compute the representation error for the training images (3)

image_len = length(A(:,1));
num_eigens = 25;
% 25 biggest eigen faces
W = eigenVectorsCov(A_meaned,num_eigens);

RMSE_mean = 0; 
DRE_mean = 0;
% matrix for all projected images of the train set
Y_train = zeros(num_eigens,trainset_num);

% project each image of the train set
for i=1:trainset_num
    % original image
    x_j = A(:,i);
    % original meaned image
    x_j_m = A_meaned(:,i);
    % projected image
    y_j = W'*(x_j_m);
    Y_train(:,i) = y_j;
    % image reconstructed
    x_j_r = mean_image + W*y_j;
    % dynamic range error
    DRE = mean(x_j_r-x_j-min(x_j_r-x_j))/(max(x_j_r-x_j)-min(x_j_r-x_j));
    DRE_mean = DRE_mean + DRE;
    % scale the reconstructed image to 256 grayscale
    x_j_r_scaled = 255/(max(x_j_r)-min(x_j_r))*(x_j_r-min(x_j_r));
    % root mean square deviation
    RMSE = sqrt(sum(((x_j-x_j_r_scaled)/255).^2)/image_len);
    RMSE_mean = RMSE_mean + RMSE;
end
DRE_mean = DRE_mean/trainset_num;
RMSE_mean = RMSE_mean/trainset_num;

%% Compute the representation error for the test images. Classify the test images and report error rate (4)

is_face = logical(is_face);
i = 1:testset_num;
% take only the faces
i = i(is_face);
% matrix for all projected images of the train set
Y_test = zeros(num_eigens,length(i));
% train KNN;
Mdl = fitcknn(Y_train',train_face_id');

results = zeros(1,length(i));

RMSE_mean = 0; 
DRE_mean = 0;

% close all;
j = 1;
for i=1:testset_num
    % original image
    x_j = double(eval("image"+num2str(i)));
    x_j = x_j(:);
    % original meaned image
    x_j_m = x_j - mean_image;
    % projected image
    y_j = W'*(x_j_m);
  
    if(is_face(i)) 
        Y_test(:,j) = y_j; 
        % predict test image
        results(j) = Mdl.predict(y_j');
%         % compare predictions
%         figure
%         subplot(2,1,1)
%         imshow(reshape(x_j,size(image1)),[]);
%         subplot(2,1,2)
%         imshow(reshape(A(:,((results(j)-1)*10+1)),size(image1)),[]);
        j = j + 1;
    end
    
    % image reconstructed
    x_j_r = mean_image + W*y_j;
    % dynamic range error
    DRE = mean(x_j_r-x_j-min(x_j_r-x_j))/(max(x_j_r-x_j)-min(x_j_r-x_j));
    DRE_mean = DRE_mean + DRE;
    % scale the reconstructed image to 256 grayscale
    x_j_r_scaled = 255/(max(x_j_r)-min(x_j_r))*(x_j_r-min(x_j_r));
    % root mean square deviation
    RMSE = sqrt(sum(((x_j-x_j_r_scaled)/255).^2)/image_len);
    RMSE_mean = RMSE_mean + RMSE;
end
DRE_mean = DRE_mean/testset_num;
RMSE_mean = RMSE_mean/testset_num;    

% classification error
gt_faces = face_id(face_id~=0);
err = mean((results ~= gt_faces));
err_cheat = mean((results(gt_faces>0) ~= gt_faces(gt_faces>0)));