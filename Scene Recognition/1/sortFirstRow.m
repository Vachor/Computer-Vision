function rlt=sortFirstRow(MulVector)
    n = length(MulVector);
    for i=1:n
       for j=i:n
           if MulVector(1,j)<MulVector(1,i)
               temp = MulVector(:,j);
               MulVector(:,j) = MulVector(:,i);
               MulVector(:,i) = temp;
           end
       end
    end
    rlt = MulVector;
end