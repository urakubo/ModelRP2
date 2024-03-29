
%%%%
%%%% Init
%%%%


	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	flag_competitive 		= 0 ; % 0: non-competitive ;  1: competitive
	flag_Gi_sequestrated_AC = 1 ; % 0: non-sequestrated;  1: sequestrated
	flag_optoDA 			= 0 ; % 0: Constant        ;  1: Opto
	flag_duration 			= -1; % -1: Persistent drop; 0: No pause; >0: pause duration;

	stop_time  = 6;
	Toffset    = 3;
	[model, species, params, container] = ...
		msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration, stop_time, Toffset);

	sd   = sbiosimulate(model);


%%%
	trange  = [-1.5,1.5];

	fig     = figure;
	yrange1 = [-0.2, 0.6];
	a1 = plot_prep(fig, trange, yrange1, 'Time (s)', '(uM)', 1);

	tname = 'DA';
	[T, DATA] = obtain_profile(tname, sd, Toffset);
	plot(a1, trange, [0 0], 'k:');
	plot(a1, T, DATA, 'k-', 'LineWidth',2);
	yticks([0, 0.05, 0.5]);


	yrange = [0,110];
	a2 = plot_prep(fig, trange, yrange, 'Time (s)', '(%Total)', 5);

	tname = 'ACprimed';
	[T, DATA] = obtain_profile(tname, sd, Toffset);
	t_half    = obtain_half(tname, sd, Toffset);
	data_half = interp1(T, DATA, t_half);

	plot(a2, [0 0], yrange, 'k:');
	plot(a2, [1 1]*t_half, yrange, 'k:');
	plot(a2, trange, [1 1]*100, 'k:');
	plot(a2, T, DATA*100, 'k-', 'LineWidth',2);
	plot(a2, t_half, data_half*100, 'ro', 'MarkerFaceColor','r','MarkerSize',4);



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

