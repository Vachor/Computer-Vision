function dist = NormOfAll(vector1,vector2)
    dist = 0;
    for i=1:length(vector1)
        dist = dist +(vector1(i)-vector2(i))^2;
    end
    dist = sqrt(dist);
end