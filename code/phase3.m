% 3 Phase Detect Color, Take all the 
	  Image_red = visualLocal(:,:,1);
    Image_green = visualLocal(:,:,2);
    Image_blue = visualLocal(:,:,3);
    
    [x, y, z] = size(visualLocal);
    
    for l=1:x
        for j=1:y
        
            Red = double(Image_red(l,j)); 
            Green = double(Image_green(l,j)); 
            Blue = double(Image_blue(l,j)); 
        
            NormalizedRed(l,j) = Red/sqrt(Red^2 + Green^2 + Blue^2); 
            NormalizedGreen(l,j) = Green/sqrt(Red^2 + Green^2 + Blue^2);
            NormalizedBlue(l,j) = Blue/sqrt(Red^2 + Green^2 + Blue^2);
        
        end
    end
    
    NormalizedRed = NormalizedRed/sqrt(3);
    NormalizedGreen = NormalizedGreen/sqrt(3);
    NormalizedBlue = NormalizedBlue/sqrt(3);

    Image_normalizedRGB = cat(3,(NormalizedRed),(NormalizedGreen),(NormalizedBlue));
    
    temporal = Image_normalizedRGB;
    
	pixels = im2bw(visualLocal, 120/255);
    pixels = imcomplement(pixels); % Complement the imgae
    pixels = bwareaopen(pixels, 500);	
    
	[x,y] = find(pixels==1); % Coordinates of the pixels in white (in the color image, with color)
   
    for j=1:length(x)   
       temporalR(j) = temporal(x(j),y(j),1);
       temporalG(j) = temporal(x(j),y(j),2);
       temporalB(j) = temporal(x(j),y(j),3); 
    end
    
    temporalR = mean(temporalR);
    temporalG = mean(temporalG);
    temporalB = mean(temporalB);
  
    RGB = [temporalR temporalG temporalB];
    
    if( find(RGB == max(RGB))==1 )
      
        if (abs(RGB(1) - RGB(3) ) <=0.012)
            card(i).Color = 'Blue';
        else
            card(i).Color = 'Red';
        end
	end
	if (find(RGB == max(RGB))==2)
		card(i).Color = 'Green';
	end
	if (find(RGB == max(RGB))==3)
		card(i).Color = 'Blue';
    end
