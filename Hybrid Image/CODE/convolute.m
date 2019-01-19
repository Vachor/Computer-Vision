function convolution = convolute(image,template)
    [imageRow, imageColum] = size(image);
    [templateRow, templateColum] = size(template);
    
    temp = zeros(imageRow,imageColum);
    
    rowi = floor(templateRow/2)+1;
    columj = floor(templateColum/2)+1;
    
    for i=rowi:imageRow-rowi+1 %i,j is the centrel point of the template.
        for j=columj:imageColum-columj+1
             %caculate sum
             sum = 0;
            for ci = 1:templateRow
                for cj=1:templateColum
                    %-1 means no change at first loop.
                    sum = sum + template(ci,cj)*image(i-floor(templateRow/2)+ci-1,j-floor(templateColum/2)+cj-1);
                end
            end
            temp(i,j) = sum;
        end
    end
    
    convolution = temp;
end