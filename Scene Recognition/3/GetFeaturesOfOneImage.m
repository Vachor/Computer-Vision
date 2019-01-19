function featureOfimg=GetFeaturesOfOneImage(img,C,n)
    img = single(img);
    featureOfimg = zeros(1,n);
    Is = vl_imsmooth(img,sqrt((8/3)^2 - .25));  
    [f,d] = vl_dsift(Is,'size',8);    % f means the position   d means the every point's descripto1
    d = double(d);
    d = d';
    
    temp = zeros(1,n);
    for i=1:length(d(:,1))
        for j=1:n
            temp(j) = norm(d(i,:)-C(j,:));
        end
        featureOfimg(temp == min(temp)) = featureOfimg(temp == min(temp))+1;
    end
end