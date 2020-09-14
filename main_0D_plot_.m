
%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	%%% Fig1C
	targs_plot  = {'DA','Gi_unbound_AC'};
	yranges  = {[-0.12, 1]*0.8,  [-0.04,0.25]};

	targs = {{'D2R'}, {'RGS','D2R'},{}};
	colors  = { [1 1 1]*0.4, [1 1 1]*0.7, [1 1 1]*0 };
	linew = { 0.5, 0.5, 2 };
	mult  = 1./5;

	%%%% S1 Fig 
	targs_plot  = {'DA','DA_D2R','Gi_unbound_AC','Gi_Gbc', ...
		'Gi_GTP','Gi_GDP','AC1_Gi_GDP','AC1_Gi_GTP'};
	pm = [-0.12, 1];
	yranges  = {pm*0.8, pm*0.02, pm*0.25, pm*15, ...
		 pm*0.5, pm*0.5, pm*0.25,  pm*0.25 };
	targs = {{}};
	colors  = {[1 1 1]*0 };
	linew = {2};
	mult  = 1;

	%%%

	[model, species, params, Toffset] = msn_setup(0);

	check = 0;
	durDA = 1;
	[model, species, params, Toffset] = msn_setup(check);
	model.Parameters(14).Value = durDA;

%%%

	trange  = [-1,3];
	ylegend  = '(uM)';

%%
%% Prep. figures
%%
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
%%
%%
	for j = 1:numel(targs);
		targ = targs{j};
		reservs = change_conc(targ, species, mult);
		sd   = sbiosimulate(model);
		restore_conc(targ, species, reservs);
		for i = 1:numel(targs_plot);
			[T, DATA] = obtain_profile(targs_plot{i}, sd, Toffset);
			plot(a{i}, T, DATA, '-', 'LineWidth', linew{j}, 'Color', colors{j});
		end
	end
%%%
%%%


function reservs = change_conc(targ, species, mult)
	reservs = {};
	for i = 1: numel(targ)
		reservs{i} = species{targ{i},'Obj'}.InitialAmount;
		species{targ{i},'Obj'}.InitialAmount = reservs{i} * mult;
	end
end


function restore_conc(targ, species, reservs)
	for i = 1: numel(targ)
		species{targ{i},'Obj'}.InitialAmount = reservs{i};
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

