function sum=SumOfAll(vector)
    sum = 0;
    for i=1:length(vector)
        sum = sum+vector(i);
    end
end