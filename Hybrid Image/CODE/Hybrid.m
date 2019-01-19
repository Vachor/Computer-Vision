close all;
clear all;
cat = imread('../image/dog.bmp');
cat = uint8(cat);
a = length(cat(:,1,1));     %get the length of first dimension
b = length(cat(1,:,1));     %get the length of second dimension
c = length(cat(1,1,:));     %get the length of third dimension
templateCat = CreateGaussianTemplate(4);
GaussianCat = zeros(a,b,c);     %Edge complement 0 
GaussianCat(:,:,1) = convolute(cat(:,:,1),templateCat);  %make a convolution in first dimension
GaussianCat(:,:,2) = convolute(cat(:,:,2),templateCat);  %make a convolution in second dimension
GaussianCat(:,:,3) = convolute(cat(:,:,3),templateCat);  %make a convolution in third dimension
imshow(uint8(GaussianCat));


dog = imread('../image/cat.bmp');
dog = double(dog);

templateDog = CreateGaussianTemplate(4);
GaussianDog = zeros(a,b,c);
GaussianDog(:,:,1) = convolute(dog(:,:,1),templateDog);
GaussianDog(:,:,2) = convolute(dog(:,:,2),templateDog);
GaussianDog(:,:,3) = convolute(dog(:,:,3),templateDog);
Hdog = dog-GaussianDog;

for i=1:a
    for j=1:b
        for k=1:c
            Hdog(i,j,k) = Hdog(i,j,k) + 20;
        end
    end
end


imshow(uint8(Hdog));


HybridImage = zeros(a,b,c);

for i=1:a
    for j=1:b
        for k=1:c
            HybridImage(i,j,k) = (GaussianCat(i,j,k) + Hdog(i,j,k));
        end
    end
end
imshow(uint8(HybridImage));

%create 3 different size images
Hybrid1 = imresize(HybridImage,0.5);
Hybrid2 = imresize(HybridImage,0.5*0.5);
Hybrid3 = imresize(HybridImage,0.5*0.5*0.5);
%make the 3 different size image the same width
Hybrid1(a,length(Hybrid1(1,:,1)),c) = 255;
Hybrid2(a,length(Hybrid2(1,:,1)),c) = 255;
Hybrid3(a,length(Hybrid2(1,:,1)),c) = 255;

%combine all the 4 image matrices together
combineImage = [HybridImage,Hybrid1,Hybrid2,Hybrid3];
%make the black to white
for i=1:a
    for j=1:length(combineImage(1,:,1))
        for k=1:c
            if combineImage(i,j,k) == 0
                combineImage(i,j,k) = 255;
            end
        end
    end
end
imshow(uint8(combineImage));
