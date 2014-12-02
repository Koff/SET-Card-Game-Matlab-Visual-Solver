

Image_red = IMG(:,:,1);
Image_green = IMG(:,:,2);
Image_blue = IMG(:,:,3);

[x, y, z] = size(IMG);

for i=1:x
    for j=1:y
        
        Red = double(Image_red(i,j)); 
        Green = double(Image_green(i,j)); 
        Blue = double(Image_blue(i,j)); 
        
        NormalizedRed(i,j) = Red/sqrt(Red^2 + Green^2 + Blue^2); 
        NormalizedGreen(i,j) = Green/sqrt(Red^2 + Green^2 + Blue^2);
        NormalizedBlue(i,j) = Blue/sqrt(Red^2 + Green^2 + Blue^2);
        
    end
end

NormalizedRed = NormalizedRed/sqrt(3);
NormalizedGreen = NormalizedGreen/sqrt(3);
NormalizedBlue = NormalizedBlue/sqrt(3);

Image_normalizedRGB = cat(3,uint8(NormalizedRed),uint8(NormalizedGreen),uint8(NormalizedBlue));