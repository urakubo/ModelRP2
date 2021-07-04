
% Init

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

% Params

	targs_plot  = {'DA', 'ACprimed'};
	duration_DA = [0.5, 1, 2];
	linew       = {2,2,2};
	k           = [0,0,0];
	colors      = {k+0.6,k+0.3,k+0.0};

	flag_competitive 		= 0; % 0: non-competitive ; 1: competitive
	flag_Gi_sequestrated_AC = 1; % 0: non-sequestrated; 1: sequestrated
	flag_optoDA 			= 0; % 0: Constant        ; 1: Opto
	flag_duration 			= 1; % -1: Persistent drop; 0: No pause; >0: pause duration;

	stop_time  = 15;
	Toffset_DA = 10;

	[model, species, params, container] = ...
		msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration, stop_time, Toffset_DA);
	trange   = [-1,3];
	xlegend  = 'Time (s)';
	ylegend  = '(uM)';
	d_DA   = container('duration_DA');


% Run & Plot

	fig = figure;
	for j = 1:numel(duration_DA);
		a{j} = plot_prep(fig, trange, [0, 1.05], targs_plot{1}, xlegend, ylegend, j);
	end
	a{4} = plot_prep(fig, trange, [0, 110], targs_plot{2}, xlegend, ylegend, 4);
	plot(a{4}, trange, [1, 1]*100, 'k:', 'LineWidth', 0.5);


	for j = 1:numel(duration_DA);
		d_DA.Value = duration_DA(j);
		sd = sbiosimulate(model);

		[T, DATA] = obtain_profile(targs_plot{1}, sd, Toffset_DA);
		plot(a{j}, T, DATA, '-', 'LineWidth', linew{j}, 'Color', colors{j});

		[T, DATA] = obtain_profile(targs_plot{2}, sd, Toffset_DA);
		plot(a{4}, T, DATA*100, 'LineWidth',2, 'Color', colors{j});
	end


function ax = plot_prep(fig, xx, yy, titl, xtitle, ytitle, i)
	ii = i - 1;
	col = floor(ii / 4);
	row = mod(ii, 4);

	if row == 3
		ax = axes(fig, 'Position',[(0.08+col*0.3), 0.1,  0.15*1.5,  0.2]); %%
	else
		ax = axes(fig, 'Position',[(0.08+col*0.3), (0.80 - row*0.18),  0.15*1.5,  0.2/2.5]); %%
	end

	ax.ActivePositionProperty = 'Position';
	title(titl,'interpreter','none');
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ytitle );
	xlim(xx);
	ylim(yy);
end

