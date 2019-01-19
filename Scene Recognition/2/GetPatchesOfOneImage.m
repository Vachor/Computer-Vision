function patches = GetPatchesOfOneImage(img,xSam,ySam)
    numRowPatches = 8;
    numColumPatches = 8;
    img = imresize(img,[xSam*numRowPatches ySam*numColumPatches]);
    patches = zeros(numRowPatches*numColumPatches,xSam*ySam);
    
    count = 0;
    for i=1:numRowPatches
        for j=1:numColumPatches
            temp = img((i-1)*xSam+1:i*xSam,(j-1)*ySam+1:j*ySam);
            count = count + 1;
            patches(count,:) = changeToOneRow(temp);
        end
    end
    
    for i=1:length(patches(:,1))            %normalising
        patches(i,:) = patches(i,:)-mean(patches(i,:));
        patches(i,:) = patches(i,:)/std(patches(i,:));
    end
end
