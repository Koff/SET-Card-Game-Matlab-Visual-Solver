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