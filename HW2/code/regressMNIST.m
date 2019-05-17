function [ accuracy ] = regressMNIST(trainSet, testSet, nKernel, learningRate)
 % trainSet:     The training set.
 % testSet:      The validation set.
 % nKernel:      The number of kernels of the first layer.
 % learningRate: The learning rate.

XTrain = trainSet{1};
YTrain = trainSet{2};

XTest = testSet{1};
YTest = testSet{2};

nk1 = nKernel;
nk2 = nKernel * 2;
nk3 = nKernel * 4;

layers = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(3,nk1,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,nk2,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,nk3,'Padding','same')
    batchNormalizationLayer
    reluLayer

    fullyConnectedLayer(10)
    softmaxLayer
    sseClassificationLayer('sse')];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',learningRate, ...
    'MaxEpochs',8, ...
    'Verbose',false, ...
    'ValidationData',testSet, ...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,layers,options);

prediction = predict(net,XTest);
[~,YPred] = max(prediction, [],2);
accuracy = sum(YPred == double(YTest))/numel(YTest);

fprintf('Regression Accuracy = %f\n', accuracy);


end