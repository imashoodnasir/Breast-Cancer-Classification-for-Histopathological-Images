clear;
close all;
clc;

img = imread('D:\Practice\Computer_Vision\Dataset\Diabetic_Retinopathy_Imbalanced\train1_0\10_left.jpeg');
img = rgb2gray(imresize(img,0.25));

figure('units','normalized','outerposition',[0 0 1 1]),
subplot(221),imshow(img), title('Original Resized Image');
[row,col]=size(img);
cropped_img=imcrop(img,[row/2 100 200 col/2]);

subplot(222),imshow(cropped_img), title('Sub-Region');
%% Normalized Cross-Correlation and Find Coordinates of Peak
% c = normxcorr2(sub_onion(:,:,1),sub_peppers(:,:,1));
% figure, surf(c), shading flat

c = normxcorr2(cropped_img,img);

%Find the peak in cross-correlation.
[ypeak, xpeak] = find(c==max(c(:)));

% Account for the padding that normxcorr2 adds.
yoffSet = ypeak-size(cropped_img,1);
xoffSet = xpeak-size(cropped_img,2);

%% Display the matched area.
subplot(223)
imshow(img), title('Normalized Cross-Correlation Output');
imrect(gca, [xoffSet+1, yoffSet+1, size(cropped_img,2), size(cropped_img,1)]);