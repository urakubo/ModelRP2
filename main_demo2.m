
% Init

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

% Fig1C

	targ_plot  = 'ACprimed';
	linew = {2,2,2};

	targs = {{'D2R','RGS'}, {'D2R','RGS'},{}};
	k = [0,0,0];
	colors = {k+0.6,k+0.3,k+0.0};
	mults = {[1, 10], [1, 0.1],[]};

	linew = { 1.5, 1.5, 1.5 };

	flag_competitive 		= 0; % 0: non-competitive ; 1: competitive
	flag_Gi_sequestrated_AC = 1; % 0: non-sequestrated; 1: sequestrated
	flag_optoDA 			= 0; % 0: Constant        ; 1: Opto
	flag_duration 			= 1; % -1: Persistent drop; 0: No pause; >0: pause duration;

	stop_time  = 6;
	Toffset_DA = 3;

	[model, species, params, container] = ...
	msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration, stop_time, Toffset_DA);
	trange   = [-1,3];
	ylegend  = '(uM)';

% Run & Plot

	fig = figure;
	a = plot_prep(fig, trange, [-10, 110], targ_plot, 'Time (s)', ylegend, 4);
	plot(a, trange, [1, 1]*100, 'k:', 'LineWidth', 0.5);
	plot(a, trange, [1, 1]*0, 'k:', 'LineWidth', 0.5);

	for j = 1:numel(targs);
		sd = run_sbiosimulate(model, species, targs{j}, mults{j})
		[T, DATA] = obtain_profile(targ_plot, sd, Toffset_DA);
		plot(a, T, DATA*100, 'LineWidth',2, 'Color', colors{j});
	end



function sd = run_sbiosimulate(model, species, targ, mult)
	reservs = change_conc(targ, species, mult);
	sd = sbiosimulate(model);
	restore_conc(targ, species, reservs);
end


function reservs = change_conc(targ, species, mult)
	reservs = {};
	for k = 1: numel(targ)
		reservs{k} = species{targ{k},'Obj'}.InitialAmount;
		species{targ{k},'Obj'}.InitialAmount = reservs{k} * mult(k);
	end
end


function restore_conc(targ, species, reservs)
	for k = 1: numel(targ)
		species{targ{k},'Obj'}.InitialAmount = reservs{k};
	end
end


function ax = plot_prep(fig, xx, yy, titl, xtitle, ytitle, i)
	ii = i - 1;
	col = floor(ii / 3);
	row = mod(ii, 3);
	ax = axes(fig, 'Position',[(0.08+col*0.3), (0.75 - row*0.33),  0.15*1.5,  0.2]); %%

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


