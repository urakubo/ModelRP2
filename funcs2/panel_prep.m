
function ax1 = panel_prep(xx, yy, zz, xtitle, ytitle)
	fig = figure('pos',[200 200 400 400],'PaperUnits','inches','PaperPosition',[2 2 4 4]);
	fig.Renderer='Painters';
	ax1 = axes('Position',[0.2 0.2 0.4 0.4]);
	ax1.ActivePositionProperty = 'Position';
	box off;
	set(ax1,'TickDir','out');
	set(ax1, 'YDir', 'normal');

	hold on;
	% axis square;
	ylabel( ytitle );
	xlabel( xtitle );

	xlim( xx );
	ylim( yy );

	colormap(jet(30));
end



