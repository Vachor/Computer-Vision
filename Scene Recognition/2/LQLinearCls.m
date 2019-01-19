function label=LQLinearCls(testData,trainData)
    X = trainData(:,1:length(trainData(1,:))-1);
    Y = trainData(:,length(trainData(1,:)));
    Y = Y';
    
    num=length(X(:,1));          %元素数量
    k=180;            %迭代次数
    step=0.1;       %迭代步长
    c = length(X(1,:));
    w(1,:)=ones(1,c);

    predY=zeros(1,num);     %迭代输出的值 y=w0+w1x1+w2x2
    e=zeros(1,k);       %均方误差

    for j=1:k

        tmp_2=0;
        for i=1:num
            predY(i)=w(j,:)*X(i,:)';
            tmp_2=tmp_2+(Y(i)-predY(i)).^2;
        end
        e(j)=0.5*tmp_2; 

        for i=1:3   
            w(j+1,i)=w(j,i)+step*(Y-predY)*X(:,i);      %迭代得到新的权值
        end
    end
    
    label = w(j+1,:)*testData';
end