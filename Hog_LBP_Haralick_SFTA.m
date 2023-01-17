clc
clear all
pathname='D:\Study\Matlab_Codes\Datasets\Fire';
imagespath=imageSet(pathname,'recursive');
imagecount=1;
allfoldernames= struct2table(dir(pathname));
for (i=3:height(allfoldernames))
    new(i-2)=allfoldernames.name(i);
end
for i=1 : size(imagespath,2)
    m=size(imagespath(i).ImageLocation,2);
    temp=imagespath(i).ImageLocation;
        for j=1 :  m
            v{imagecount,1}=temp{j};
            if(~isempty(strfind(temp{j},new(1,i))))
                v{imagecount,2}=new(1,i);    
            else
                v{imagecount,2}='None';
            end
%           if(~isempty(strfind(temp{j},'accordion')))
%               v{imagecount,2}='accordin';
%           else
%               v{imagecount,2}='o';
%           end         
            img=imread(v{imagecount,1});
%             I2=augments(img);
%             imwrite(Noise, [currentFolder '\' new_name ext], ext(2:end));
            if(size(img, 3) == 3)
            img=double(rgb2gray(img));
            end
            covector=graycomatrix(img);
            img=imresize(img,[227,227]);
%%            
            [featureVectorHoG, hogVisualization] = extractHOGFeatures(img);
            featureVectorLBP = extractLBPFeatures(img);
            featureVectorHaralick = haralickTextureFeatures(covector);
            featureVector2Safta=sfta(img,4);
            
%%     
            Feature_HoG{imagecount,1}=featureVectorHoG(1,:);   
            Feature_LBP{imagecount,1}=featureVectorLBP(1,:);
            Feature_Haralick{imagecount,1}=featureVectorHaralick(1,:);
            Feature_SFTA{imagecount,1}=featureVector2Safta(1,:);
%%       
        imagecount=imagecount+1;
     end
end
%%Creating Feature Vector
for i=1:length(Feature_HoG)
    ftemp=double(Feature_HoG{i});
    FV_HoG(i,:)=ftemp;
end
for i=1:length(Feature_LBP)
    ftemp1=double(Feature_LBP{i});
    FV_LBP(i,:)=ftemp1;
end
for i=1:length(Feature_Haralick) 
    ftemp2=double(Feature_Haralick{i});
    FV_Haralick(i,:)=ftemp2;
end
for i=1:length(Feature_SFTA)
    ftemp3=double(Feature_SFTA{i});
    FV_SFTA(i,:)=ftemp3;
end

%% Saving Feature Vector Without Labels For Entropy and other Selection
%methods


%% Standalone Feature Vectors with Labels
Labels=v(:,2);
F_HoG=cell2table(horzcat(Labels,num2cell(FV_HoG)));
F_LBP=cell2table(horzcat(Labels,num2cell(FV_LBP)));
F_Haralick=cell2table(horzcat(Labels,num2cell(FV_Haralick)));
F_SFTA=cell2table(horzcat(Labels,num2cell(FV_SFTA)));

%% Entropy Based Selection
%Entropy on HoG Features 
[Row_HoG, Column_HoG]=size(FV_HoG);
Score_HoG = Find_Entropy(FV,Column_HoG);
Reduced_HoG_Entropy_Features = real(Score_HoG(:,1:3935));

%Entropy on LBP Features
[Row_LBP, Column_LBP]=size(FV_LBP);
Score_LBP = Find_Entropy(FV1,Column_LBP);
Reduced_LBP_Entropy_Features = Score_LBP(:,1:50);

%Entropy on Haralick Features
[Row_Haralick, Column_Haralick]=size(FV_Haralick);
Score_Haralick = Find_Entropy(FV2,Column_Haralick);
Reduced_Haralick_Entropy_Features = Score_Haralick(:,1:15);

%Entropy on SFTA Features
[Row_SFTA, Column_SFTA]=size(FV_SFTA);
Score_SFTA = Find_Entropy(FV3,Column_SFTA);
Reduced_SFTA_Entropy_Features = Score_SFTA(:,1:15);
  
Reduced_Entropy_Fused_Features = horzcat(Reduced_LBP_PCA_Features,Reduced_LBP_Entropy_Features, red_dim_SFTA );
Feature_Vector_After_Entropy=cell2table(horzcat(Labels,num2cell(Reduced_Entropy_Fused_Features)));

%% PCA based reduction
[PC_HOG,Score_HoG] = pca(FV_HoG);
[PC_LBP,Score_LBP] = pca(FV_LBP); save
[PC_Haralick,Score_Haralick] = pca(FV_Haralick);
[PC_SFTA,Score_SFTA] = pca(FV_SFTA);
Reduced_HoG_PCA_Features = Score_HoG(:,1:440);
Reduced_LBP_PCA_Features = Score_LBP(:,1:40);
Reduced_Haralick_PCA_Features = Score_Haralick(:,1:10);
Reduced_SFTA_PCA_Features = Score_SFTA(:,1:20);
Reduced_PCA_Fused_Features = horzcat(Reduced_SFTA_PCA_Features,Reduced_HoG_PCA_Features, Reduced_LBP_Entropy_Features, Reduced_Haralick_PCA_Features);
Feature_Vector_After_PCA=cell2table(horzcat(Labels,num2cell(Reduced_PCA_Fused_Features)));

%% $erialBasesFusion    
%    fused=horzcat(red_dim_Hog,red_dim_LBP,red_dim_Texture,red_dim_SFTA);   %% All
%    fused1=horzcat(red_dim,red_dim1);                    %hog  lbp
%    fused2=horzcat(red_dim1,red_dim2);                   %lbp  sfta
%    fused3=horzcat(red_dim2,red_dim3);                   %sfta surf
%    fused4=horzcat(red_dim,red_dim3);                     %hog sfta
%    fused5=horzcat(red_dim1,red_dim2,red_dim3);          %lbp surf sfta
%    fused6=horzcat(red_dim,red_dim2,red_dim3);           %lbp surf sfta
%    fused7=horzcat(red_dim,red_dim1,red_dim3);           %lbp surf sfta
%    fused8=horzcat(red_dim,red_dim1,red_dim2);           %hog lbp sfta
%%

   f_HoG=cell2table(horzcat(Labels,num2cell(red_dim)));
   % f1=cell2table(horzcat(X,num2cell(fused1)));
%    f2=cell2table(horzcat(X,num2cell(fused2)));
%    f3=cell2table(horzcat(X,num2cell(fused3)));
%    f4=cell2table(horzcat(X,num2cell(fused4)));
%    f5=cell2table(horzcat(X,num2cell(fused5)));
%    f6=cell2table(horzcat(X,num2cell(fused6)));
%    f7=cell2table(horzcat(X,num2cell(fused7)));
%    f8=cell2table(horzcat(X,num2cell(fused8)));
   % x feature vector
%     x=red_dim2;
%     % y is label
%     y=X;
% svmmodel=fitcecoc(x,y);
% save svmmodel;
% %%  Testing
% load('svmmodel.mat');
% 
% [filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick a Leaf Image File');
% imgname=horzcat(pathname,filename)
% [class,dimg]=tellmeClass( imgname ,svmmodel);
% 
% %% Inserting Class Label
% [r c j]=size(dimg);
% position = [(r/2),2];
% value = char(class(1));
% RGB = insertText(dimg,position,value);
% figure,imshow(RGB),title('Numeric values');
