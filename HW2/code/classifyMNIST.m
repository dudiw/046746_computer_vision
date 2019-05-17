function [] = classifyMNIST(trainSet, testSet, nKernel, learningRate)
 % trainSet:     The training set.
 % testSet:      The validation set.
 % nKernel:      The number of kernels of the first layer.
 % learningRate: The learning rate.
 
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
    classificationLayer];
      
options = trainingOptions('sgdm', ...
    'InitialLearnRate',learningRate, ...
    'MaxEpochs',8, ...
    'Shuffle','every-epoch', ...
    'ValidationData',testSet, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'MiniBatchSize',128, ...
    'Plots','training-progress'); 

net = trainNetwork(trainSet,layers,options);

YPred = classify(net,testSet); 
YValidation = testSet.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation);

end