
%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	init_font;

%%% Init

	targs_plot = {'DA', 'Gi_GTP', 'Gi_unbound_AC'};
	trange   = [-1,4];
	yranges  = {[-0.08, 0.8], [-0.05,0.5], [-0.014, 0.14]};
	ylegend  = '(uM)';

	targs_change = {{} ,{'D2R','RGS'}, {'D2R','RGS'}, {'D2R','RGS'}};
	targs_change_title = {'Healthy adult', 'Healthy infant', 'Schizophrenia', 'Dystonia'};
	mults = {[], [0.5,0.5], [4.0, 0.5], [0.5, 2.0]};

	durDA = 0.01*2.^[0:8]
	NUMd  = numel(durDA);
	cols = ones(1,3).*[(NUMd-1:-1:0)/NUMd]';
	for i = 1:numel(durDA); durDA_leg{i} = sprintf('%g s', durDA(i)); end

	check = 0;
	[model, species, params, Toffset] = msn_setup(check);
	
%	DA_basal = species{'DA_basal','Obj'}.InitialAmount;
%	species{'DA_dip','Obj'}.InitialAmount = DA_basal / 10;


%%% Figs and sims

	fig  = figure();
	loc = fig.Position;
	fig.Position = [loc(1),loc(2),loc(3)*1.5,loc(4)];
	for k = 1:numel(targs_change);

		a = {};
		for i = 1:numel(targs_plot);
			a{i} = plot_prep(fig, trange, yranges{i}, 'Time (s)', ylegend, i, k);
			title(a{i}, targs_plot{i},'Interpreter','none');
			plot(a{i}, trange, [0 0], 'k:');
		%%
			if strcmp(targs_plot{i}, 'Gi_GTP') & strcmp(targs_change_title{k}, 'Schizophrenia')
				ylim(a{i},  yranges{i}*10);
				plot(a{i}, trange, [1 1]*yranges{i}(2), 'k:');
			end
		%%
			if strcmp(targs_plot{i}, 'Gi_unbound_AC')
				AC1 = species{'AC1','Obj'}.InitialAmount;
				plot(a{i}, trange, [1 1]*AC1, 'k:');
			end
		%%
		end
		%%
		title(a{1}, targs_change_title{k},'Interpreter','none');
		yticks(a{1},[0 0.5]);
		yticks(a{3},[0 0.1]);
		%%

		for j = 1:NUMd
			model.Parameters(14).Value = durDA(j);
			sd = run_sbiosimulate(model, species, targs_change{k}, mults{k});
			for i = 1:numel(targs_plot);
				[T, DATA] = obtain_profile(targs_plot{i}, sd, Toffset);
				plot(a{i}, T, DATA, '-', 'LineWidth', 1.5, 'Color', cols(j,:));
			end
		end
		model.Parameters(14).Value = 100000;
		sd = run_sbiosimulate(model, species, targs_change{k}, mults{k});
		% [io, idip] = Obtain_Io_Idip(sd, Toffset);
		% fprintf('%s, Io: %g, Idip; %g\n', targs_change_title{k}, io, idip);
		[Gi_GTPo, Gi_GTPdip] = Obtain_Gi_GTP(sd, Toffset);
		fprintf('%s, Gi_GTPo: %g uM, Gi_GTPdip; %g uM\n', targs_change_title{k}, Gi_GTPo, Gi_GTPdip);
	end
%%%


function [io, idip] = Obtain_Io_Idip(sd, Toffset)
		AC1tot     = obtain_conc('AC1', sd, 0);
		AC1GTP     = obtain_conc('AC1_Gi_GTP', sd, Toffset);
		AC1GDP     = obtain_conc('AC1_Gi_GDP', sd, Toffset);
		AC1GTP_end = sd.Data(end, find( strcmp( sd.DataNames, 'AC1_Gi_GTP' )) );
		AC1GDP_end = sd.Data(end, find( strcmp( sd.DataNames, 'AC1_Gi_GDP' )) );
		io         =  ( AC1GTP + AC1GDP )./AC1tot;
		idip       =  ( AC1GTP_end + AC1GDP_end )./AC1tot;
end


function [Gi_GTPo, Gi_GTPdip] = Obtain_Gi_GTP(sd, Toffset)
		Gi_GTPo   = obtain_conc('Gi_GTP', sd, Toffset);
		Gi_GTPdip = sd.Data(end, find( strcmp( sd.DataNames, 'Gi_GTP' )) );
end


function sd = run_sbiosimulate(model, species, targ, mult)
	reservs = {};
	for i = 1: numel(targ)
		reservs{i} = species{targ{i},'Obj'}.InitialAmount;
		species{targ{i},'Obj'}.InitialAmount = reservs{i} * mult(i);
	end
	sd = sbiosimulate(model);
	for i = 1: numel(targ)
		species{targ{i},'Obj'}.InitialAmount = reservs{i};
	end
end


function ax = plot_prep(fig, xx, zz , xtitle, ztitle, row, col)
	row = row - 1;
	col = col - 1;

	% [(0.15+col*0.4), (0.15+row*0.3)]
	ax = axes(fig, 'Position',[0.1 + col*0.2, (0.75-row*0.28),  0.14,  0.17]);
	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ztitle );
	xlim(xx);
	ylim(zz);
end

