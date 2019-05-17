%% 046746 Computer Vision - HW2
% Task A. Training a simple CNN

%% Task A section 4

digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', 'nndatasets','DigitDataset');
dataStore = imageDatastore(digitDatasetPath, 'IncludeSubfolders',true,'LabelSource','foldernames');

numTrainFiles = 750;
[trainSet,testSet] = splitEachLabel(dataStore,numTrainFiles,'randomize');

nKernel = 8;
learningRate = 0.01;

trainMNIST(trainSet, testSet, nKernel, learningRate, classificationLayer);

%% Task A section 7.1 - Learning rate 0.1

digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', 'nndatasets','DigitDataset');
dataStore = imageDatastore(digitDatasetPath, 'IncludeSubfolders',true,'LabelSource','foldernames');

numTrainFiles = 750;
[trainSet,testSet] = splitEachLabel(dataStore,numTrainFiles,'randomize');

nKernel = 8;
learningRate = 0.1;

trainMNIST(trainSet, testSet, nKernel, learningRate, classificationLayer);

%% Task A section 7.2 - Learning rate 0.0001

digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', 'nndatasets','DigitDataset');
dataStore = imageDatastore(digitDatasetPath, 'IncludeSubfolders',true,'LabelSource','foldernames');

numTrainFiles = 750;
[trainSet,testSet] = splitEachLabel(dataStore,numTrainFiles,'randomize');

nKernel = 8;
learningRate = 0.0001;

trainMNIST(trainSet, testSet, nKernel, learningRate, classificationLayer);

%% Task A section 7.3 - Regression layer

nKernel = 8;
learningRate = 0.01;

[XTrain,YTrain,~]           = digitTrain4DArrayData;
[XValidation,YValidation,~] = digitTest4DArrayData;

regressMNIST({XTrain,YTrain}, {XValidation,YValidation}, nKernel, learningRate);

%% Task A section 8 - Fewer kernels

nKernel = 2;
learningRate = 0.01;

[XTrain,YTrain,~]           = digitTrain4DArrayData;
[XValidation,YValidation,~] = digitTest4DArrayData;

regressMNIST({XTrain,YTrain}, {XValidation,YValidation}, nKernel, learningRate);

