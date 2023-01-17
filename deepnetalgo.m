% %https://www.mathworks.com/help/vision/examples/image-category-classification-using-deep-learning.html
clear all
clc
close all
% end
%% Dataset Paths
outputFolder='D:\Datasets\';
rootFolder = fullfile(outputFolder, 'small');

allfoldernames= struct2table(dir(rootFolder));
for (i=3:height(allfoldernames))
    new(i-2)=allfoldernames.name(i);
end
clear i
categories=new;
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource','foldernames');
tbl = countEachLabel(imds);
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
% Use splitEachLabel method to trim the set.
% imds = splitEachLabel(imds, minSetCount, 'randomize');
imds = splitEachLabel(imds, minSetCount, 'random');
% Notice that each set now has exactly the same number of images.
countEachLabel(imds);


%%

% Find the first instance of an image for each category
%% Pretrained Net AlexNet
net = efficientnetb0();
% net = xception();
% net = inceptionv3();
% net = darknet53();
% net = resnet50();
net.Layers(1);
net.Layers(end);

imr=net.Layers(1, 1).InputSize(:,1);
imc=net.Layers(1, 1).InputSize(:,2);

imds.ReadFcn = @(filename)readAndPreprocessImage(filename,imr,imc);
[trainingSet, testSet] = splitEachLabel(imds, 0.7, 'random');
% Get the network weights for the second convolutional layer
% w1 = net.Layers(2).Weights;
%%   Resize weigts for vgg only
% w1 = imresize(w1,[imr imc]);
%%
% For VGG19
% featureLayer = 'global_average_pooling2d_2';

% For Alexnet
% featureLayer = 'fc7';

% For InceptionV3
% featureLayer = 'global_average_pooling2d_1';

% For DenseNet201
featureLayer = 'efficientnet-b0|model|head|global_average_pooling2d|GlobAvgPool';

% For Nasnetlarge
% featureLayer = 'global_average_pooling2d_2';

% For Darknet53
% featureLayer = 'avg1';
% tic
%%
trainingFeatures = activations(net, trainingSet, featureLayer, ...
 'MiniBatchSize', 16, 'OutputAs', 'columns');

%%
% Get training labels from the trainingSet
trainingLabels = cellstr(trainingSet.Labels);


%%
%%
% Extract test features using the CNN
% testFeatures = activations(net, testSet, featureLayer, ...
%  'MiniBatchSize', 16, 'OutputAs', 'columns');

x = trainingFeatures';
y = cellstr(trainingLabels);
xy = array2table(x);
xy.type = y;

save('fire_new_train_vgg19_');
