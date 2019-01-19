function GaussianTemplate = CreateGaussianTemplate(sigma)
    Tsize = floor(8*sigma + 1);
    if rem(Tsize,2) == 0
        Tsize = Tsize + 1;
    end
    temp = zeros(Tsize,Tsize);
    summ = 0;
    centre = floor(Tsize/2)+1;
    for i=1:Tsize
        for j=1:Tsize
            temp(i,j) = exp(-(((j-centre)^2+(i-centre)^2))/(2*sigma^2));
            summ = summ + temp(i,j);
        end
    end
    
    for i=1:Tsize
        for j=1:Tsize
            temp(i,j) = temp(i,j)/summ;   %normalise every element
        end
    end
    GaussianTemplate = temp;
end