clear all;
close all;
img = imread('testing/6.jpg');
img = double(img);


AllPatches = zeros(8*15*100,4*4);            %the colum represent features of one patch.  we should cluster all the pathes.
count = 0;
for i=1:15
    if i==1
        prefix = 'training/bedroom/';
    elseif i==2
        prefix = 'training/Coast/';
    elseif i==3
        prefix = 'training/Forest/';
    elseif i==4
        prefix = 'training/Highway/'; 
    elseif i==5
        prefix = 'training/industrial/';
    elseif i==6
        prefix = 'training/Insidecity/';  
    elseif i==7
        prefix = 'training/kitchen/';   
    elseif i==8
        prefix = 'training/livingroom/';   
    elseif i==9
        prefix = 'training/Mountain/';  
    elseif i==10
        prefix = 'training/Office/';
    elseif i==11
        prefix = 'training/OpenCountry/';
    elseif i==12
        prefix = 'training/store/';
    elseif i==13
        prefix = 'training/Street/';
    elseif i==14
        prefix = 'training/Suburb/';
    else
        prefix = 'training/TallBuilding/';
    end
    for j=0:99
        filename = [num2str(j) '.jpg'];
        tempForSingleImage = imread([prefix filename]);
        tempForSingleImage = double(tempForSingleImage);
        count = count+1;
        OneImagePatches = GetPatchesOfOneImage(tempForSingleImage,4,4);        %get a matrix of which colum represent the feature of one patch, row represent all the pathes of one image.
        AllPatches((count-1)*length(OneImagePatches(:,1))+1:count*length(OneImagePatches(:,1)),:) = OneImagePatches;
    end
end




[C,idx] = vl_kmeans(AllPatches',500);  %idx is the classification of each points. % C is the 500central points' position
% [idx,C] = KMeans(AllPatches,500);
 C = C';

%start to train the model.

count = 0;
labelledData = zeros(1500,1);
InputMatrix = zeros(1500,500);
for i=1:15
    if i==1
        prefix = 'training/bedroom/';
    elseif i==2
        prefix = 'training/Coast/';
    elseif i==3
        prefix = 'training/Forest/';
    elseif i==4
        prefix = 'training/Highway/'; 
    elseif i==5
        prefix = 'training/industrial/';
    elseif i==6
        prefix = 'training/Insidecity/';  
    elseif i==7
        prefix = 'training/kitchen/';   
    elseif i==8
        prefix = 'training/livingroom/';   
    elseif i==9
        prefix = 'training/Mountain/';  
    elseif i==10
        prefix = 'training/Office/';
    elseif i==11
        prefix = 'training/OpenCountry/';
    elseif i==12
        prefix = 'training/store/';
    elseif i==13
        prefix = 'training/Street/';
    elseif i==14
        prefix = 'training/Suburb/';
    else
        prefix = 'training/TallBuilding/';
    end
    for j=0:99
        filename = [num2str(j) '.jpg'];
        tempForSingleImage = imread([prefix filename]);
        tempForSingleImage = double(tempForSingleImage);
        count = count+1;
        featuresOFimg = GetFeaturesOfOneImage(tempForSingleImage,C);
        InputMatrix(count,:) = featuresOFimg;
        labelledData(count) = i;
    end
end

imgFeature = GetFeaturesOfOneImage(img,C);
InputMatrix = [InputMatrix labelledData];


N = length(InputMatrix(:,1));
indices = crossvalind('Kfold',N,10);
for i=1:10
    test = (indices == i);
    train = ~test;
    trainValData = InputMatrix(train,:);
    testValData = InputMatrix(test,:);
end

targetY = testValData(:,length(testValData(1,:)));
testValData = testValData(:,1:length(testValData(1,:))-1);
accRate = 0;

label = zeros(1,length(testValData(:,1)));
for j=1:length(testValData(:,1))
    label(j)=linearCls(testValData(j,:),trainValData);
    if label(j) == targetY(j)
        accRate = accRate + 1;
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
    testFeature = GetFeaturesOfOneImage(img);

    label=linearCls(testFeature,InputMatrix,C);
    output = [output;[strcat(num2str(i),".jpg ",clsLabel(label))]];
    count = count+1;
end

fid=fopen('run1.txt','wt');
for i=1:count
    fprintf(fid,'%s\n',output(i,:));
end
fclose(fid);




