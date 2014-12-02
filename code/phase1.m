% Boundaries of the image
	[B, L] = bwboundaries(smallObjects, 8, 'noholes');
	stats = regionprops(L, 'all');	% Properties of the image
	
% 1 Phase, detect Number of Objects
	card(i).NumElem = length(stats);