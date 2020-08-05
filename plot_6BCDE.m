
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

	targs = {{'D2R'}, {'RGS'},{'D2R','RGS'}, {}};
	mult  = 10;
	reservs = change_conc(targs{1}, species, mult);

%%%

	durDA = 0.01*2.^[0:7];
	NUMd  = numel(durDA);
	cols = ones(1,3).*[(NUMd-1:-1:0)/NUMd]';
	for i = 1:numel(durDA); durDA_leg{i} = sprintf('%g s', durDA(i)); end

	fig     = figure;
	trange  = [-1,3];
	yranges  = {[-0.1, 0.8], [-0.04,0.25], [-1,10]};
	ylegends = {'(uM)', '(uM)', '(uM)'};
	a = {};
	for i = 1:numel(ylegends);
		a{i} = plot_prep(fig, trange, yranges{i}, 'Time (s)', ylegends{i}, i);
		plot(a{i}, trange, [0 0], 'k:');
	end
	yticks(a{1},[0 0.5]);

%%%

	for j = 1:NUMd
		model.Parameters(14).Value = durDA(j);
		sd   = sbiosimulate(model);
		T    = {};
		DATA = {};
		[T{1}, DATA{1}] = obtain_profile('DA', sd, Toffset);
		[T{2}, DATA{2}] = obtain_profile('Gi_unbound_AC', sd, Toffset);
		[T{3}, DATA{3}] = obtain_profile('Gi_GTP', sd, Toffset);
		for i = 1:numel(T);
			plot(a{i}, T{i}, DATA{i}, '-', 'LineWidth', 1.5, 'Color', cols(j,:));
		end
	end

%%%


function ax = plot_prep(fig, xx, zz , xtitle, ztitle, i)
	row = i - 1;
	ax = axes(fig, 'Position',[0.1, (0.8-row*0.3),  0.15*1.5,  0.15]);
	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ztitle );
	xlim(xx);
	ylim(zz);
end


function reservs = change_conc(targ, species, mult)
	reservs = {};
	for i = 1: numel(targ)
		reservs{i} = species{targ{i},'Obj'}.InitialAmount;
		species{targ{i},'Obj'}.InitialAmount = reservs{i} * mult;
	end
end

