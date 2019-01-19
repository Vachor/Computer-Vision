function rlt = changeToOneRow(img)
    Size = size(img);
    rlt = zeros(1,Size(1)*(Size(2)));
    count = 0;
    for i=1:Size(1)                 %number Of row
        for j=1:Size(2)             %number Of Colum
            count = count + 1;
            rlt(count) = img(i,j);
        end
    end
%     for i=1:length(rlt(:,1))            %normalising
%         rlt(i,:) = rlt(i,:)-mean(rlt(i,:));
%         rlt(i,:) = rlt(i,:)/std(rlt(i,:));
%     end
end