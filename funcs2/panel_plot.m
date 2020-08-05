%%
%%
%%
function panel_plot(dims, targs, concs, AMP, default_conc, zminmax, tit)

	tdim = setdiff([1,2,3], dims);

	AMP = permute(AMP , [dims(2) dims(1) tdim] );
	tid = nearest_id(concs{tdim}, default_conc{tdim});
	AMP = squeeze( AMP(:,:,tid) );

	xlog_concs = log10(concs{dims(1)});
	ylog_concs = log10(concs{dims(2)});
	xminmax = [ min(xlog_concs) , max(xlog_concs) ];
	yminmax = [ min(ylog_concs) , max(ylog_concs) ];
	x_default_conc = default_conc{dims(1)};
	y_default_conc = default_conc{dims(2)};

	% ax31 = panel_prep1(xminmax, yminmax, zminmax, targs{dims(1)}, targs{dims(2)}, tit);

	fig = figure('pos',[200 200 400 400],'PaperUnits','inches','PaperPosition',[2 2 4 4]);
	ax1 = axes('Position',[0.2 0.2 0.5 0.3]);
	ax1.ActivePositionProperty = 'Position';
	box off;
	set(ax1,'TickDir','out');
	set(ax1, 'YDir', 'normal');
	title(tit,'Interpreter','none');

	hold on;
	ylabel( targs{dims(1)} );
	xlabel( targs{dims(2)} );

	xlim( xminmax );
	ylim( yminmax );

	colormap(jet(30));

%	axis square;
%	im2 = imagesc( ax31, xlog_concs, ylog_concs, AMP, zminmax );
%	colorbar
%	plot(ax31, xminmax, [log10(y_default_conc) log10(y_default_conc)], 'k--');
%	plot(ax31, [ log10(x_default_conc), log10(x_default_conc) ], yminmax, 'k--');

	surf( ax1, xlog_concs,  ylog_concs, AMP  );
	colorbar;
	zlim( zminmax );

end


