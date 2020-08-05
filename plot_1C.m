
%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	font_init;

	[model, species, params, Toffset] = msn_setup(0);
	targs = {{'D2R'}, {'RGS','D2R'},{}};
	cols = { [1 1 1]*0.4, [1 1 1]*0.7, [1 1 1]*0 };
	mult  = 1./5;
	durDA = 1;

	check = 0;
	[model, species, params, Toffset] = msn_setup(check);
	sd   = sbiosimulate(model);
	model.Parameters(14).Value = durDA;

%%%
	fig     = figure;
	trange  = [-1,3];
	yranges  = {[-0.1, 0.8], [-0.04,0.25]};
	ylegends = {'(uM)', '(uM)'};
	a = {};
	for i = 1:numel(ylegends);
		a{i} = plot_prep(fig, trange, yranges{i}, 'Time (s)', ylegends{i}, i);
		hold on;
		plot(a{i}, trange, [0 0], 'k:');
	end
	yticks(a{1},[0 0.5]);
%%%
%%%
	for j = 1:numel(targs);
		targ = targs{j};
		reservs = change_conc(targ, species, mult);
		sd   = sbiosimulate(model);
		restore_conc(targ, species, reservs);

		[T{1}, DATA{1}] = obtain_profile('DA', sd, Toffset);
		[T{2}, DATA{2}] = obtain_profile('Gi_unbound_AC', sd, Toffset);
		for i = 1:numel(T);
			plot(a{i}, T{i}, DATA{i}, '-', 'LineWidth', 1.5, 'Color', cols{j});
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

function ax = plot_prep(fig, xx, zz , xtitle, ztitle, i)
	row = i - 1;
	ax = axes(fig, 'Position',[0.1, (0.6-row*0.4),  0.15*1.5,  0.2]);
	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ztitle );
	xlim(xx);
	ylim(zz);
end

