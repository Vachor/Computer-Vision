function label = KNN(testData,trainingData,k)
    X = trainingData(:,1:length(trainingData(1,:))-1);              %prepare for X
    Y = trainingData(:,length(trainingData(1,:)));              %prepare for Y
    
    numOfClass = 15;
    numOfEveryClass = zeros(1,numOfClass);
    for i=1:numOfClass
        numOfEveryClass(i)=length(find(Y==i));          % get a count of each class
    end
    accumulateEveryClass = zeros(1,numOfClass);         %get a accumulation from 1 to n class 
    for i=1:numOfClass
        if i==1
            accumulateEveryClass(i) = numOfEveryClass(i);
        else
            accumulateEveryClass(i) = accumulateEveryClass(i-1)+numOfEveryClass(i);
        end
    end
    dist = zeros(numOfClass,100);
    dist =dist+99999999;
    
    for i=1:numOfClass
        for j=1:length(find(Y==i))             %length of every label's count.
            if i==1
                dist(i,j) = NormOfAll(testData,X(j,:));
            else
                dist(i,j) = NormOfAll(testData,X(accumulateEveryClass(i-1)+j,:));      %every row means the class, colum means every distance of every image in this class.
            end
        end
    end
    

%     dist = (sort(dist'))';   %sort for dist, make the first colum the minimun element.
    rlt = changeToOneRow(dist);
    tempY = zeros(1,1500);
    for i=1:15
        tempY((i-1)*100+1:100*i) = i;
    end
    rlt = [rlt;tempY];
    rlt=sortFirstRow(rlt);
    temp=tabulate(rlt(2,1:k));
    label=temp(temp(:,2)==max(temp(:,2)),1);
    
%     temp = zeros(1,numOfClass);
%     for i=1:numOfClass
%         temp(i) = SumOfAll(dist(i,1:k));
%     end
% 
%     label = find(temp==MinOfAll(temp));
    label=label(ceil(rand*length(label)),1);
end