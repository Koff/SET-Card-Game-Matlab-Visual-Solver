% Remove the white background and cut the image

function  [Set] = SET(IMG)

I2 = imcrop(IMG,[62 618 1750 1500]); 
thresh =110;
cards = im2bw(I2, thresh/255);
visual = imresize(I2, 0.5);
% Resize the image
cards = imresize(cards, 0.5);

% Fill the holes 
BW2 = imfill(imcomplement(cards),'holes');
smallObjects = bwareaopen((BW2), 1000);
BW2 = (smallObjects);

% Boundaries of the image
[B, L] = bwboundaries(smallObjects, 8, 'noholes');

% Find the card's figures
imshow(label2rgb(L));

% Stats of the image
stats = regionprops(L,'all');

% Asign the field NAME to the stats depending on their area
for i=1:length(stats)
   
		if (stats(i,1).Area > 2500  && stats(i,1).Area < 3300)
			stats(i,1).Name = 'Rhombus';
		end
		
		if (stats(i,1).Area > 3300  && stats(i,1).Area < 4000)
			stats(i,1).Name = 'Squirky';
		end
		
		if (stats(i,1).Area > 4000 )
			stats(i,1).Name = 'Pill';
		end
end


% Coordinates of each card

x = 1:292:877;
y = 1:188:753;
k=1;
for i=1:length(x)-1
    for j=1:length(y)-1
        
        card(k).xi = x(i);
        card(k).xf = x(i+1);
        
        card(k).yi = y(j);
        card(k).yf = y(j+1);

        k=k+1;
    end
end

for j=1:length(stats)
        
    centros(j,1) = stats(j).Centroid(1);
    centros(j,2) = stats(j).Centroid(2);
end

for i=1:length(card)
   
    temp1 =find(centros(:,1) > card(i).xi); 
    temp2 =find(centros(:,1) < card(i).xf);
    temp3 =find(centros(:,2) > card(i).yi );
    temp4 =find(centros(:,2) < card(i).yf);
    
    temp1 = intersect(temp1,temp2);
    temp1 = intersect(temp1,temp3);
    temp1 = intersect(temp1,temp4);
    
    card(i).NumElem = length(temp1);
    card(i).Name = stats(temp1(1)).Name;
    
    [x,y] = find(temp1(1)==L);
   
    pixels = im2bw(visual(min(x):max(x),min(y):max(y), :), 130/255);
    pixels = imcomplement(pixels);
    temporal = visual(min(x):max(x),min(y):max(y), :);
    [x,y] = find(pixels == 1);
   
    for j=1:length(x)
       temporalR(j) = temporal(x(j),y(j),1); 
    end
    for j=1:length(x)
       temporalG(j) = temporal(x(j),y(j),2); 
    end
    for j=1:length(x)
       temporalB(j) = temporal(x(j),y(j),3); 
    end
    
    temporalR = mean(temporalR);
    temporalG = mean(temporalG);
    temporalB = mean(temporalB);
  
    RGB = [temporalR temporalG temporalB];
  
    if ( find(RGB == max(RGB))==1 )
      card(i).Color = 'Red';
      if ( abs(RGB(1)-RGB(3)) < 10 )
        card(i).Color = 'Blue';
     end
  end
  if (find(RGB == max(RGB))==2)
      card(i).Color = 'Green';
  end
  if (find(RGB == max(RGB))==3)
      card(i).Color = 'Blue';
  end
  
    [a b c] = size(temporal);
  
    BW3=rgb2gray(temporal);
    BW3=edge(BW3,'roberts',0.05);
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
   
    if( strcmp(card(i).Name,'Squirky'))
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

hold on
for i=1:12
    text(card(i).xi,card(i).yi,num2str(card(i).NumElem));
    text(card(i).xi,card(i).yi+20,num2str(card(i).Name));
    text(card(i).xi,card(i).yi+40,num2str(card(i).Color));
    text(card(i).xi,card(i).yi+60,num2str(card(i).Fill));
end

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


end



    


