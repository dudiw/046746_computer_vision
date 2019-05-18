%% 046746 Computer Vision - HW2
% Task B. Using a Pre-trained network

clc; close all; clear all;

path_images = fullfile('..','CNN Images');

% Task B section 1 - Load the trained model 
net = vgg16();

% Task B section 2 - Load images and classify
label = 'birds';
path_labelled = fullfile(path_images, label);
image_files = dir(fullfile(path_labelled,'*.jpg'));

count = numel(image_files);

for k = 1:count
    file = image_files(k);
    image = containers.Map();
    image_url = fullfile(file.folder, file.name);
    image('data') = imread(image_url);
    image('name') = file.name;
    
    result = classifyVGG16(net, image);
    
    subplot(count, 1, k);
    name = result('name');
    imshow(imtile({result('original'), result('resized')}));
    title({'Image: Original and Transformed', name},'Interpreter','none');
    xlabel(result('prediction'));
end

%% Task B section 3 - Classify an image from the web
custom_url = 'http://www.robots.ox.ac.uk/~vgg/data/pets/data/images/samoyed_11.jpg';
image_name = 'samoyed_11.jpg';

image = containers.Map();
image('data') = imread(custom_url);
image('name') = image_name;

net = vgg16();
result = classifyVGG16(net, image);

figure;
imshow(imtile({result('original'), result('resized')}));
title({'Image: Original and Transformed', image_name},'Interpreter','none');
xlabel(result('prediction'));

%% Task B section 4 - Custom image manipulation and classification
% Use a geometric transform, a color transform and a filter
% Show the resulting images and their classification

close all; clc;

custom_url = 'http://www.robots.ox.ac.uk/~vgg/data/pets/data/images/';
image_name = 'samoyed_11.jpg';
image_url = strcat(custom_url, image_name);
I = imread(image_url);

images = cell(4);
image_original = containers.Map();
image_original('data') = I;
image_original('name') = 'Samoyed: Original';
images{1} = image_original;

% Geometric transformation - rotate image by 45 degrees counterclockwise
I_rotated = imrotate(I, 45, 'bilinear', 'crop');
image_rotated = containers.Map();
image_rotated('data') = I_rotated;
image_rotated('name') = 'Samoyed: Rotated 45° counterclockwise';
images{2} = image_rotated;

% Color transformation - Histogram Equalisation
% Convert to HSV color space, equalize histogram of the intensity channel
I_hsv = rgb2hsv(I);
I_equalized = histeq(I_hsv(:,:,3));
I_modified = I_hsv;
I_modified(:,:,3) = I_equalized;
I_color_modified = hsv2rgb(I_modified);
I_color_modified = uint8(255 .* I_color_modified);
image_color_modified = containers.Map();
image_color_modified('data') = I_color_modified;
image_color_modified('name') = 'Samoyed: Color transformation';
images{3} = image_color_modified;

% Filtering - sharpen the image using unsharp masking
% by subtracting the gaussian-blurred image from itself
I_sharpen = imsharpen(I);
image_filtered = containers.Map();
image_filtered('data') = I_sharpen;
image_filtered('name') = 'Samoyed: Filtered - Sharpening';
images{4} = image_filtered;

% Display resulting images
figure;
subplot(1,4,1);
imshow(I);
title({'Image:','Original'});
subplot(1,4,2);
imshow(I_rotated);
title({'Image:','Geometric transform'});
xlabel('Rotated 45° counterclockwise');
subplot(1,4,3);
imshow(I_color_modified);
title({'Image:','Color transformation'});
xlabel('Histogram Equalization');
subplot(1,4,4);
imshow(I_sharpen);
title({'Image:','Filtered'});
xlabel('Sharpening');

[count,~] = size(images);

% Classify images
net = vgg16();

figure;

results = cell(count);
for k = 1:count
    image = images{k};
    result = classifyVGG16(net, image);
    
    subplot(2,2, k);
    imshow(imtile({result('original'), result('resized')}));
    title(result('name'),'Interpreter','none');
    xlabel(result('prediction'));
    
    act1 = activations(net, image('data'), 'conv1_1');
    sz = size(act1);
    act1 = reshape(act1,[sz(1) sz(2) 1 sz(3)]);
    result('response') = act1;
   
    results{k} = result;
end

% Task B section 5
% The first convolution layer 'conv1_1' (index 2)
channels = 1:2;
filters = deepDreamImage(net,2,channels,...
    'PyramidLevels',1, ...
    'Verbose', false);
figure;
imshow(imtile(filters,'ThumbnailSize',[64 64]));
title({'VGG16: Layer features','conv1_1'},'Interpreter','none');

% Show the filter response of 'conv1_1' to the images
activation = cell(k,1);
figure;
for k = 1:count
    result = results{k};
    index = (k - 1) * 2 + 1;
    subplot(count, 2, index);
    original = result('original');
    imshow(original);
    title(result('name'),'Interpreter','none');
    xlabel(result('prediction'));
    
    act1 = result('response');
    activation{k} = act1;
    response = imtile(mat2gray(act1),'GridSize',[1 2]);
    subplot(count, 2, index + 1);
    imshow(response);
    title({'VGG16 Conv Layer', 'Filter response'});
    xlabel('Response of 2 filters in conv1_1','Interpreter','none');
end

diff = activation{1} - activation{count};
response = imtile(mat2gray(diff),'GridSize',[1 2]);
figure;
imshow(response);
title(['VGG16 Conv Layer Response: ', 'Original vs Sharpened']);
xlabel('Response of 2 filters in conv1_1','Interpreter','none');

%% Task B section 6 - Feature vector of Fully connected layer

close all; clc; clear all;

path_images = fullfile('..','CNN Images');

url_custom = 'http://www.robots.ox.ac.uk/~vgg/data/pets/data/images/';
url_cat = strcat(url_custom,'Maine_Coon_133.jpg');
url_dog = strcat(url_custom,'samoyed_11.jpg');

url_wiki = 'https://upload.wikimedia.org/wikipedia/commons/';
url_tiger = strcat(url_wiki,'d/d4/Siberian_Tiger_by_Malene_Th.jpg');
url_wolf = strcat(url_wiki,'thumb/f/ff/JAA_3538-2.jpg/1280px-JAA_3538-2.jpg');

layer = 'fc7';     % Fully Connected layer #7 
N     = 4096;      % Weights of fully connected layer #7 
sz    = [224 244]; % Input size fully connected layer #7 

% Load images: Cats and Dogs
path_labelled = fullfile(path_images, 'cats');
files_cats = dir(fullfile(path_labelled,'*.jpg'));

path_labelled = fullfile(path_images, 'dogs');
files_dogs = dir(fullfile(path_labelled,'*.jpg'));

count_cats = numel(files_cats);
count_dogs = numel(files_dogs);
count_images = count_cats + count_dogs;
image_urls = cell(count_images + 4, 1);
for k = 1:count_cats
    file = files_cats(k);
    image_urls{k} = fullfile(file.folder, file.name);
end

indices_cats = 1 : count_cats;

for k = 1:count_dogs
    file = files_dogs(k);
    image_urls{k + count_cats} = fullfile(file.folder, file.name);
end

indices_dogs = count_cats + 1 : count_images;

% Custom images
k = count_images;
index_cat   = k + 1;
index_dog   = k + 2;
index_tiger = k + 3;
index_wolf  = k + 4;
image_urls{index_cat}   = url_cat;
image_urls{index_dog}   = url_dog;
image_urls{index_tiger} = url_tiger;
image_urls{index_wolf}  = url_wolf;

% Cats and Dogs - Extract feature vectors of layer 'FC7'
images = cell(count_images);
features = zeros(count_images, N);

net = vgg16();
for k = 1:numel(image_urls)
    image = imread(image_urls{k});
    images{k} = image;
    
    % Adjust size of the image
    image_resized = imresize(image, [sz(1) sz(2)]);
    fc = activations(net, image_resized, layer);
    features(k,:) = squeeze(fc);
end

indices_image  = 1:count_images;
image_features = features(indices_image,:);
distance_cat   = pdist2(features(index_cat,  :), image_features);
distance_dog   = pdist2(features(index_dog,  :), image_features);
distance_tiger = pdist2(features(index_tiger,:), image_features);
distance_wolf  = pdist2(features(index_wolf, :), image_features);
[dist_cat,   match_cat]   = min(distance_cat);
[dist_dog,   match_dog]   = min(distance_dog);
[dist_tiger, match_tiger] = min(distance_tiger);
[dist_wolf,  match_wolf]  = min(distance_wolf);

subplot(4, 2, 1);
imshow(imtile(images(indices_cats),'GridSize',[2 5]));
title('Images: Cats');

subplot(4, 2, 3);
imshow(imtile(images(indices_dogs),'GridSize',[2 5]));
title('Images: Dogs');

subplot(4, 2, 5);
imshow(imtile({images{index_cat}, images{match_cat},...
    images{index_dog}, images{match_dog}},'GridSize',[2 2]));
title('Images: Pet image similarity');

subplot(4, 2, 7);
imshow(imtile({images{index_tiger}, images{match_tiger},...
    images{index_wolf}, images{match_wolf}},'GridSize',[2 2]));
title('Images: Predetor image similarity');

subplot(4, 2, [2 4 6 8]);

color_cats  = [0.53 0.8 1];
color_cat   = 'b';
color_tiger = [0 0 0.5];

color_dogs  = [1 0.85 0];
color_dog   = [1 0.55 0];
color_wolf  = [0.82 0.41 0.11];

[~,scores,~] = pca(features);
score_cats  = scores(indices_cats,:);
score_dogs  = scores(indices_dogs,:);
score_cat   = scores(index_cat,:);
score_dog   = scores(index_dog,:);
score_tiger = scores(index_tiger,:);
score_wolf  = scores(index_wolf,:);
scatter3(score_cats(:,1),score_cats(:,2),score_cats(:,3),[],...
    'MarkerEdgeColor', color_cats,...
    'MarkerFaceColor',color_cats,...
    'DisplayName','Cats',...
    'LineWidth',1.5);
hold on
scatter3(score_dogs(:,1),score_dogs(:,2),score_dogs(:,3),[],...
    'MarkerEdgeColor',color_dogs,...
    'MarkerFaceColor',color_dogs,...
    'DisplayName','Dogs',...
    'LineWidth',1.5);
hold on
scatter3(score_cat(:,1),score_cat(:,2),score_cat(:,3),[],...
    'MarkerEdgeColor',color_cat,...
    'MarkerFaceColor',color_cat,...
    'DisplayName','Cat',...
    'LineWidth',0.6);
hold on
scatter3(score_dog(:,1),score_dog(:,2),score_dog(:,3),[],...
    'MarkerEdgeColor',color_dog,...
    'MarkerFaceColor',color_dog,...
    'DisplayName','Dog',...
    'LineWidth',0.6);
hold on
scatter3(score_tiger(:,1),score_tiger(:,2),score_tiger(:,3),[],...
    'MarkerEdgeColor',color_tiger,...
    'MarkerFaceColor',color_tiger,...
    'DisplayName','Tiger',...
    'LineWidth',0.6);
hold on
scatter3(score_wolf(:,1),score_wolf(:,2),score_wolf(:,3),[],...
    'MarkerEdgeColor',color_wolf,...
    'MarkerFaceColor',color_wolf,...
    'DisplayName','Wolf',...
    'LineWidth',0.6);
axis equal
legend('Position',[0.7088 0.7034 0.1778 0.1957])
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component');
title('FC7: PCA Visualization');


