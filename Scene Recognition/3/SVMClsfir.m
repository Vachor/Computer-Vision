function label=SVMClsfir(testData,trainData)
    X = trainData(:,1:length(trainData(1,:))-1);
    Y = trainData(:,length(trainData(1,:)));
    
    AllY = -ones(length(Y(:,1)),15);
    for i=1:15
        AllY(Y==i,i) = 1;
    end
    

    lambda = 0.01;
    maxIter = 2000;
    for i=1:15
        [w b info]=vl_svmtrain(X',AllY(:,i)',lambda,'MaxNumIterations',maxIter);
    end
    
    temp = zeros(1,1000);
    for i=1:1000
        temp(i)=X(i,:)*w+b
    end
end