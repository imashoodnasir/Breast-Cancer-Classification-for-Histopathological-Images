function Iout = readAndPreprocessImage(img1,imr,imc) 
    I = imread(img1);
    if(size(I, 3) == 1)
        I = cat(3,I,I,I);
    end
    if ismatrix(I)
        I = cat(3,I,I,I);
    end
    Iout = imresize(I, [imr imc]);
end