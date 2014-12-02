%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	SET GAME SOLVER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creator, Fernando San Martin Jorquera 
% email, fsanmartinjorquera@uh.edu
% Granada (Spain)


% The function recieves an Image in JPEG taken in specific conditions (see methods) and gives back how many sets
% he found in that image as well as the cards involved. Cards are numbered vertically, so for example card 4, is the botton
% left card.

%function  [Set] = SET2(IMG)

% Cuts, resizes and transforms to B/W the image
numCards=12;
I2 = imcrop(IMGIn,[62 618 1750 1500]); % Cropping
thresh =110;						% Threshold value to convert the image to b/w.
cards = im2bw(I2, thresh/255);		% B/W
visual = imresize(I2, 0.5);			% Visual is the color image, mainly for illustration purposses
cards = imresize(cards, 0.5);		% Cards is the image in B/W, to work on!

% Next Step to cut the cards of the image in 12 differents
x = 1:292:877;  % This are the coordinates to cut the image
y = 1:188:753;	% Extracted empirically
k=1;
for i=1:length(x)-1
    for j=1:length(y)-1

		card(k).xi = x(i);  % X Axis
        card(k).xf = x(i+1);
        
        card(k).yi = y(j);	% Y Axis
        card(k).yf = y(j+1);

        k=k+1;
    end
end
% To avoid errors in the parallel for loop, the structure card needs to be initialiciated.

for i = 1:numCards
	card(i).NumElem = 0;
	card(i).Name = '';
	card(i).Color = '';
	card(i).Fill = '';
end

t = cputime;
for i=1:numCards

	visualLocal = visual(card(i).yi:(card(i).yf-3), card(i).xi:(card(i).xf-3) ,:);  % Cut the chunk of image that we want to study
	cardsLocal = cards(card(i).yi:(card(i).yf-3) , card(i).xi:(card(i).xf-3));%
	BW2 = imfill(imcomplement(cardsLocal),'holes');		% Fill the holes
	smallObjects = bwareaopen((BW2), 1000);		% Remove Samll obejcts (< 1000 pixels)
	
	% Boundaries of the image
	[B, L] = bwboundaries(smallObjects, 8, 'noholes');
	stats = regionprops(L, 'all');	% Properties of the image
	
	% 1 Phase, detect Number of Objects
	card(i).NumElem = length(stats);
	
	% 2 Phase, detect shape, the Area is a good differenciator
	if (stats(1,1).Area > 2500  && stats(1,1).Area < 3300)
        card(i).Name = 'Rhombus';
    end
    
    if (stats(1,1).Area > 3300  && stats(1,1).Area < 4000)
        card(i).Name = 'Squiggly';
    end
    
    if (stats(1,1).Area > 4000 )
        card(i).Name = 'Pill';
    end
	
	% 3 Phase Detect Color, Take all the 
% 	thres2=130;
% 	pixels = im2bw(visualLocal, 130/255);
%     pixels = imcomplement(pixels); % Complement the imgae
% 	pixels = bwareaopen((pixels), 1000);
% 	[x,y] = find(pixels==1); % Coordinates of the pixels in white (in the color image, with color)
% 
% 	
%     for j=1:length(x)
%        temporalR(j) = temporal(x(j),y(j),1);
%        temporalG(j) = temporal(x(j),y(j),2);
%        temporalB(j) = temporal(x(j),y(j),3); 
%     end
%     
%     temporalR = mean(temporalR);
%     temporalG = mean(temporalG);
%     temporalB = mean(temporalB);
%   
%     RGB = [temporalR temporalG temporalB];
%   
%     if ( find(RGB == max(RGB))==1 )
%       card(i).Color = 'Red';
%       if ( abs(RGB(1)-RGB(3)) < 18 )  % Red and blue are close colors in the pics, this is to correct some of the mis classifications
% 			card(i).Color = 'Blue';
% 		end
% 	end
% 	if (find(RGB == max(RGB))==2)
% 		card(i).Color = 'Green';
% 	end
% 	if (find(RGB == max(RGB))==3)
% 		card(i).Color = 'Blue';
%     end
% 	
%     
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

    
	% 4 Phase, Shading detector, using an edge detection method.
    [x,y] = find(L==1);
	temporal = visualLocal(min(x):max(x),min(y):max(y),:);
	[a b c] = size(temporal);
  
    BW3=rgb2gray(temporal);
    BW3=edge(BW3,'roberts',0.05);	% Robert method, the best tried so far, again, parameter extracted from empiral trials
    [x] = length(find(BW3==1));
    
    if( strcmp(card(i).Name, 'Rhombus'))
       ratio = x/(a*b);
       if(ratio>0.0 && ratio <0.079)
          card(i).Fill = 'Filled'; 
       end
       
       if(ratio>=0.079 && ratio <0.15)
          card(i).Fill = 'Empty'; 
       end
       
       if(ratio>=0.15 && ratio <=1)
          card(i).Fill = 'Shaded'; 
       end
   end
  
   if(strcmp(card(i).Name,'Pill'));
       
       ratio = x/(a*b);
       if(ratio>0.0 && ratio <0.0807)
          card(i).Fill = 'Filled'; 
       end
       
       if(ratio>=0.0807 && ratio <0.2028)
          card(i).Fill = 'Empty'; 
       end
       
       if(ratio>=0.2028 && ratio <=1)
          card(i).Fill = 'Shaded'; 
       end
   end
   
    if( strcmp(card(i).Name,'Squiggly'))
       ratio = x/(a*b);
       if(ratio>0.0 && ratio <0.0953)
          card(i).Fill = 'Filled'; 
       end
       
       if(ratio>=0.0953 && ratio <0.201)
          card(i).Fill = 'Empty'; 
       end
       
       if(ratio>=0.201 && ratio <=1)
          card(i).Fill = 'Shaded'; 
       end
	end
end
e=cputime-t;

%%%%%%%%%%%%%%
% Calculate Set
%%%%%%%%%%%%%%

 nameEqual=0;
 colorEqual=0;
 numberEqual=0;
 fillEqual=0;
m=1;
 
for i=1:12
    for j=1:12
            for k=1:12
                 if ( length (unique([i j k])) <3 )
                    % Evita formar sets consigo mismo
                 else
                   
                     if (strcmp(card(i).Name,card(j).Name))
                         if (strcmp(card(i).Name,card(k).Name)) 
                            nameEqual=1;
                         end
                     else
                         if ((strcmp(card(i).Name,card(k).Name)))
                         
                         else
                            if ((strcmp(card(j).Name,card(k).Name) ) == 0)    
                                nameEqual=1;
                            end
                         end
                     end
                    
                     if (strcmp(card(i).Color,card(j).Color))
                         if (strcmp(card(i).Color,card(k).Color))
                            colorEqual=1;
                         end
                     else
                         if ((strcmp(card(i).Color,card(k).Color)))
                         
                         else
                            if ((strcmp(card(j).Color,card(k).Color) ) == 0)    
                                colorEqual=1;
                            end
                         end
                     end
                     
                     if (strcmp(card(i).Fill,card(j).Fill))
                         if (strcmp(card(i).Fill,card(k).Fill))
                            fillEqual=1;
                         end
                     else
                         if ((strcmp(card(i).Fill,card(k).Fill)))
                         
                         else
                            if ((strcmp(card(j).Fill,card(k).Fill) ) == 0)    
                                fillEqual=1;
                            end
                         end
                     end
                     
                  
                    if ((card(i).NumElem==card(j).NumElem))
                         if ((card(i).NumElem==card(k).NumElem))
                            numberEqual=1;
                         end
                     else
                         if (((card(i).NumElem==card(k).NumElem)))
                         
                         else
                            if (((card(j).NumElem==card(k).NumElem) ) == 0)    
                                numberEqual=1;
                            end
                         end
                    end
                     
                    if (numberEqual==1 && colorEqual==1 && fillEqual==1 && nameEqual==1)
                        Set(m,:,:,:)=[i j k];
                        m=m+1;
                    end
                 end
                 
            nameEqual=0;
            colorEqual=0;
            numberEqual=0;
            fillEqual=0;     
            end
    end 
end 

for i=1:length(Set)
		sortedSet(i,:) = sort(Set(i,:));
end
Set = unique(sortedSet,'rows');

%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%

h=figure
imshow(visual)
x = 1:292:877;  % This are the coordinates to cut the image
y = 1:188:753;	% Extracted empirically
k=1;
for i=1:length(x)-1
    for j=1:length(y)-1

		card(k).xi = x(i);  % X Axis
        card(k).xf = x(i+1);
        
        card(k).yi = y(j);	% Y Axis
        card(k).yf = y(j+1);

        k=k+1;
    end
end

markers={'+', '-','x','o','*','s','?', '#'};
[a b] = size(Set);
for i=1:a
	for j=1:b
		text(card(Set(i,j)).xi+(i*25)+20,card(Set(i,j)).yi+20,markers(i),'FontSize',20);
	end
end
saveas(h,num2str(ii),'png'); %name is a string