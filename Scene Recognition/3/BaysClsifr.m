function label=BaysClsifr(testData,trainData)
    
    X = trainData(:,1:length(trainData(1,:))-1);
    Y = trainData(:,length(trainData(1,:)));
    
    %p(class|feature) = p(feature|class)*p(class)/p(feature);
    label = zeros(1,15);
    for k=1:15
        conMtri=X(Y==k,:);
        
        temp = zeros(1,length(testData(1,:)));
        for i=1:length(testData(1,:))
            temp(i)=length(find(conMtri(:,i)==testData(i)))/length(conMtri(:,1));
        end
        p_feature_class = 1;
        for i=1:length(testData(1,:))
            p_feature_class = p_feature_class*temp(i);
        end
        
        p_class = 1/15;
        for i=1:length(testData(1,:))
            temp(i)=length(find(X(:,i)==testData(i)))/length(X(:,1));
        end
        p_feature=1;
        for i=1:length(testData(1,:))
            p_feature = p_feature*temp(i);
        end
        if p_feature == 0
            p_feature = 0.0001;
        end
        label(k) = p_feature_class*p_class/p_feature;
    end
    
    mulLabel=find(label==max(label));
    label = mulLabel(ceil(rand*length(mulLabel)));
end