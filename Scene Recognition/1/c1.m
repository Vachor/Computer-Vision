clear all;
close all;
%                 load all the image files
singleRow = 16;
singleColum = 16;
trainDataMatrix = zeros(1500,singleRow*singleColum);
labelledData = zeros(1500,1);

count = 0;
prefix = ["training/bedroom/";"training/Coast/";"training/Forest/";"training/Highway/";"training/Industrial/"; "training/Insidecity/";"training/Kitchen/";"training/Livingroom/";"training/Mountain/";"training/Office/";"training/OpenCountry/";"training/Store/";"training/Street/";"training/Suburb/";"training/TallBuilding/"];
for i=1:15
    for j=0:99
        filename = [num2str(j) '.jpg'];
        tempForSingleImage = imread(char(strcat(prefix(i),filename)));
        tempForSingleImage = double(tempForSingleImage);
        tempForSingleImage = imresize(tempForSingleImage,[singleRow singleColum]);
        
        tempForOneRow=changeToOneRow(tempForSingleImage);
        
        count = count+1;
        trainDataMatrix(count,:) = tempForOneRow;
        labelledData(count) = i;
    end
end


trainDataMatrix = [trainDataMatrix labelledData];

% 10 fold validation
N = length(trainDataMatrix(:,1));
indices = crossvalind('Kfold',N,10);
for i=1:10
    test = (indices == i);
    train = ~test;
    trainValData = trainDataMatrix(train,:);
    testValData = trainDataMatrix(test,:);
end

testValLabel = testValData(:,length(testValData));
testValData = testValData(:,1:length(testValData(1,:))-1);
predLabel = zeros(length(testValLabel(:,1)),1);

accRate = zeros(1,30);
for k=1:30              %increase k value
    
    accNum = 0;
    for i=1:length(testValData(:,1))      %get all the test data
         predLabel(i,1) = KNN(testValData(i,:),trainValData,k);
         if predLabel(i,1) == testValLabel(i,1)
             accNum = accNum+1;
         end
    end
    accRate(k) = accNum/length(testValData(:,1));  %calculate the accuracy
end
plot(1:k,accRate,'r-');
title('Accuracy Rate');
xlabel('value of k');
ylabel('accuracy rate');

maxAcc=accRate(max(accRate) == accRate);
KPos = find(max(accRate) == accRate);
meansAcc = SumOfAll(accRate)/length(accRate(1,:));
a = ['The maximun accuracy rate is %' num2str(maxAcc(1)*100)]
c = ['The mean value of rate is %' num2str(meansAcc(1)*100)]
b = ['The optimal value of k is ' num2str(KPos(1))]

% test the run
clsLabel = ["bedroom";"Coast";"Forest";"Highway";"industrial";"Insidecity";"kitchen";"livingroom";"Mountain";"Office";"OpenCountry";"store";"Street";"Suburb";"TallBuilding"];
prefix = 'testing/';
output = [];

count=0;
for i = 0:2987
    if i== 1314
        continue;
    end
    if i==2938
        continue;
    end
    if i==2962
        continue;
    end
    filename = [num2str(i) '.jpg'];
    img = imread([prefix filename]);
    img = double(img);
    img = imresize(img,[16 16]);
    testFeature = changeToOneRow(img);
    label = KNN(testFeature,trainDataMatrix,10);
    output = [output;[strcat(num2str(i),".jpg ",clsLabel(label))]];
    count = count+1;
end

fid=fopen('run1fu.txt','wt');
for i=1:count
    fprintf(fid,'%s\n',output(i,:));
end
fclose(fid);