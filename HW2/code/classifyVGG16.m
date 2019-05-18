function [result] = classifyVGG16(net, image)
 % net:        The VGG16 network.
 % image: A container holding the image data and name.

% Adjust size of the image
sz = net.Layers(1).InputSize;

I = image('data');   
image_resized = imresize(I, [sz(1) sz(2)]);

% Classify the image using VGG-16 
[YPred,scores] = classify(net, image_resized);

result = containers.Map();
result('name') = image('name');
result('original') = I;
result('resized') = image_resized;
result('label') = string(YPred);
result('score') = 100*max(scores(:));

prediction = strcat(string(YPred),", ",num2str(100*max(scores(:)),3),"%");
result('prediction') = prediction; 

end