
function PlaceThresholdBars(plotNumber, lowThresh, highThresh)
	% Show the thresholds as vertical red bars on the histograms.
	subplot(3, 4, plotNumber); 
	hold on;
	maxYValue = ylim;
	maxXValue = xlim;
	hStemLines = stem([lowThresh highThresh], [maxYValue(2) maxYValue(2)], 'r');

	% Place a text label on the bar chart showing the threshold.
	fontSizeThresh = 14;
	annotationTextL = sprintf('%d', lowThresh);
	annotationTextH = sprintf('%d', highThresh);
	% For text(), the x and y need to be of the data class "double" so let's cast both to double.
	text(double(lowThresh + 5), double(0.85 * maxYValue(2)), annotationTextL, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	text(double(highThresh + 5), double(0.85 * maxYValue(2)), annotationTextH, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	
	% Show the range as arrows.
	% Can't get it to work, with either gca or gcf.
% 	annotation(gca, 'arrow', [lowThresh/maxXValue(2) highThresh/maxXValue(2)],[0.7 0.7]);

	return; % from PlaceThresholdBars()