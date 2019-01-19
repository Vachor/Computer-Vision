function featureOfimg=GetFeaturesOfOneImage(img,C)
    featureOfimg = zeros(1,500);
    Pathces = GetPatchesOfOneImage(img,4,4);
    
    temp = zeros(1,500);
    for i=1:length(Pathces(:,1))
        for j=1:500
            temp(j) = norm([Pathces(i,:)-C(j,:)]);
        end
        featureOfimg(find(temp == min(temp))) = featureOfimg(find(temp == min(temp)))+1;
    end
end