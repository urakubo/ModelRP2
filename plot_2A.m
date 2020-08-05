
%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	font_init;


	check = 0;
	[model, species, params, Toffset] = msn_setup(check);
	sd   = sbiosimulate(model);


%%%
	fig     = figure;
	trange  = [-1,2];
	yrange1 = [-0.2, 0.6];
	a1 = plot_prep(fig, trange, yrange1, 'Time (s)', '(uM)', 1);

	tname = 'DA';
	[T, DATA] = obtain_profile(tname, sd, Toffset);

	plot(a1, trange, [0 0], 'k:');
	plot(a1, T, DATA, 'k-', 'LineWidth',2);
	yticks([0 0.5])


	yrange2 = [0,110];
	a2 = plot_prep(fig, trange, yrange2, 'Time (s)', '(%total)', 5);

	tname = 'Gi_unbound_AC';
	[T, DATA] = obtain_profile(tname, sd, Toffset);
	t_half    = obtain_half(tname, sd, Toffset);

	data_stable = interp1(T, DATA, Toffset);
	data_half   = interp1(T, DATA, t_half); % vq = interp1(x,v,xq)
	plot(a2, [0 0], yrange2, 'r:');
	plot(a2, [1 1]*t_half, yrange2, 'r:');
	plot(a2, t_half, data_half*100./DATA(end), 'ro', 'MarkerFaceColor','r','MarkerSize',4);
	plot(a2, trange, [1 1]*data_stable*100, 'r:', 'MarkerFaceColor','r','MarkerSize',4);

	plot(a2, T, DATA*100./DATA(end), 'k-', 'LineWidth',2);

%%
%%
%%


function ax = plot_prep(fig, xx, zz , xtitle, ztitle, i)
	ii = i - 1;
	row = floor(ii / 4);
	col = mod(ii, 4);
	% [(0.15+col*0.4), (0.15+row*0.3)]
	ax = axes(fig, 'Position',[(0.1+col*0.225), (0.8-row*0.3),  0.15,  0.15]);
	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ztitle );
	xlim(xx);
	ylim(zz);
end

