
% Init

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

% Fig1C

%{
	targs_plot  = {'DA','Gi_unbound_AC'};
	yranges  = {[-0.12, 1]*0.8,  [-0.02,0.12]};

	targs = {{'D2R','RGS'}, {'D2R','RGS'},{}};
	colors  = { [1 1 1]*0.7, [1 1 1]*0.4, [1 1 1]*0 };
	linew = { 1.5, 1.5, 2 };
	mults = {[4, 1], [1/4, 1],[]};
%}

% S1 Fig

%%{
	pm = [-0.12, 1];
	targs_plot  = {'DA','DA_D2R', ...
		'Gi_GTP','Gi_GDP','AC1_Gi_GDP','AC1_Gi_GTP','Golf_AC1', 'ACact'};
	yranges  = {pm*0.8, pm*0.02,  ...
		 pm*0.5, pm*0.5, pm*0.12,  pm*0.12,  pm*0.12 ,  pm};

	targs = {{}};
	colors  = {[1 1 1]*0 };
	linew   = {2};
	mults   = {1};
%%}

%
	flag_competitive 		= 1;
	flag_Gi_sequestrated_AC = 1;
	flag_optoDA 			= 1;
	flag_duration 			= 1;
	stop_time  = 6;
	Toffset_DA = 3;

	[model, species, params, container] = ...
	msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration, stop_time, Toffset_DA);
	trange   = [-1,3];
	ylegend  = '(uM)';

% Prep. figures

	a = {};
	fig     = figure;
	for i = 1:numel(targs_plot);
		a{i} = plot_prep(fig, trange, yranges{i}, targs_plot{i}, 'Time (s)', ylegend, i);
		hold on;
		plot(a{i}, trange, [0 0], 'k:');
		plot(a{i}, [0 0], [yranges{i}(2), yranges{i}(2)*0.8 - yranges{i}(1)*0.2], ...
		'r-','LineWidth',1);
	end
	yticks(a{1},[0 0.5]);

% Run & Plot
%{
	targ = 'Golf';
	init_conc = species{ targ,'Obj'}.InitialAmount;
	fprintf('%s, init conc: %g\n', targ, init_conc);
	species{ targ,'Obj'}.InitialAmount = init_conc * 10;
%}
	for j = 1:numel(targs);
		sd = run_sbiosimulate(model, species, targs{j}, mults{j})
		for i = 1:numel(targs_plot);
			[T, DATA] = obtain_profile(targs_plot{i}, sd, Toffset_DA);
			plot(a{i}, T, DATA, '-', 'LineWidth', linew{j}, 'Color', colors{j});
		end
	end

%

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


function ax = plot_prep(fig, xx, zz ,titl, xtitle, ytitle, i)
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
	ylim(zz);
end

