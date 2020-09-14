
function [fig, ax1] = panel_prep4(xx, yy, zz, xtitle, ytitle)
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

	set(gca,'XMinorTick','On');
	set(gca,'YMinorTick','On');

	set(gca, 'XScale', 'log');
	set(gca, 'YScale', 'log');

	set(gca, 'XTick', 10.^(-3:3));
	set(gca, 'YTick', 10.^(-3:3));

	set(gca, 'XTickLabel',  num2str( get(gca,'XTick')' ,'%g'));
	set(gca, 'YTickLabel',  num2str( get(gca,'YTick')' ,'%g'));


	colormap(jet(30));
end



