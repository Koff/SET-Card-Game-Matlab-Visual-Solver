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
Set = unique(sortedSet,'rows'); % Removes duplicated Sets