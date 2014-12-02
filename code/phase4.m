% 4 Phase, Shading detector, using an edge detection method.
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