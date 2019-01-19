
res = 32;
AllFeatures = zeros(64*1500,128);
count = 0;
prefix = ["training/bedroom/";"training/Coast/";"training/Forest/";"training/Highway/";"training/Industrial/"; "training/Insidecity/";"training/Kitchen/";"training/Livingroom/";"training/Mountain/";"training/Office/";"training/OpenCountry/";"training/Store/";"training/Street/";"training/Suburb/";"training/TallBuilding/"];
for i=1:15
    for j=0:99
        filename = [num2str(j) '.jpg'];
        tempForSingleImage = imread(char(strcat(prefix(i),filename)));
        tempForSingleImage = imresize(tempForSingleImage,[res res]);
        tempForSingleImage = single(tempForSingleImage);
        
        Is = vl_imsmooth(tempForSingleImage,sqrt((8/3)^2 - .25));  
        [f,d] = vl_dsift(Is,'size',8);    % f means the position   d means the every point's descripto1
        d = double(d);
        d = d';
        AllFeatures(count*64+1:count*64+64,:) = d;
        count = count+1;
    end
end

k_value_means =130;
[C idx] = vl_kmeans(AllFeatures',k_value_means);
C = C';

count = 0;
labelledData = zeros(1500,1);
InputMatrix = zeros(1500,k_value_means);

for i=1:15
    for j=0:99
        filename = [num2str(j) '.jpg'];
        tempForSingleImage = imread(char(strcat(prefix(i),filename)));
        tempForSingleImage = single(tempForSingleImage)';
        tempForSingleImage = imresize(tempForSingleImage,[res res]);
        featuresOFimg = GetFeaturesOfOneImage(tempForSingleImage,C,k_value_means);
        count = count+1;
        InputMatrix(count,:) = featuresOFimg;
        labelledData(count) = i;
    end
end



InputMatrix=[InputMatrix labelledData];
N = length(InputMatrix(:,1));
indices = crossvalind('Kfold',N,10);
test = (indices == 1);
train = ~test;
trainValData = InputMatrix(train,:);
testValData = InputMatrix(test,:);
trueValue = testValData(:,length(testValData(1,:)));
testValData = testValData(:,1:length(testValData(1,:))-1);
for i=1:length(testValData(:,1))
     label=BaysClsifr(testValData(i,:),trainValData);
   % label=SVMClsfir(testValData(i,:),trainValData);
    if label == trueValue(i)
        accRate = accRate+1;
    end
end

accRate = accRate / length(testValData(:,1));



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
    img = imresize(img,[32 32]);
    tst_ftre=GetFeaturesOfOneImage(img,C,k_value_means);
    label=BaysClsifr(tst_ftre,InputMatrix);

%     label=linearCls(testFeature,InputMatrix,C);
    output = [output;[strcat(num2str(i),".jpg ",clsLabel(label))]];
    count = count+1;
end

fid=fopen('run3.txt','wt');
for i=1:count
    fprintf(fid,'%s\n',output(i,:));
end
fclose(fid);