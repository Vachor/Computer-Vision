function min = MinOfAll(vector)
    min = 99999999;
    for i=1:length(vector)
        if vector(i)<min
            min = vector(i);
        end
    end
end