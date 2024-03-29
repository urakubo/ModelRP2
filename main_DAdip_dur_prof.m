
%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	init_font;

%%% Init


	targs_plot = {'DA', 'Gi_GTP', 'ACact'};
	trange   = [-1,4];
	yranges  = {[-0.08, 0.8], [-0.05,0.5], [0, 100]};
	mult = [1,1,100];
	ylegend  = '(uM)';

	targs_change = {{} ,{'D2R','RGS'}, {'D2R','RGS'}, {'D2R','RGS'}};
	targs_change_title = {'Healthy adult', 'Healthy infant', 'Schizophrenia', 'Dystonia'};
	mults = {[], [0.5,0.5], [4.0, 0.5], [0.5, 2.0]};

	durDA = 0.01*2.^[0:8]
	NUMd  = numel(durDA);
	cols = ones(1,3).*[(NUMd-1:-1:0)/NUMd]';
	for i = 1:numel(durDA); durDA_leg{i} = sprintf('%g s', durDA(i)); end

	flag_competitive 		= 0;%0;
	flag_Gi_sequestrated_AC = 1;
	flag_optoDA 			= 0;
	flag_duration 			= 1;
	[model, species, params, container] = msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration);
	d_DA    = container('duration_DA');
	Toffset = container('Toffset_DA').Value;

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
		%%
			switch targs_plot{i}
				case 'DA'
					plot(a{i}, trange, [0 0], 'k:');
				%%
				case 'Gi_GTP'
					plot(a{i}, trange, [0 0], 'k:');
					if strcmp(targs_change_title{k}, 'Schizophrenia')
						ylim(a{i},  yranges{i}*10);
						plot(a{i}, trange, [1 1]*yranges{i}(2), 'k:');
					end
			end
		end
		%%
		title(a{1}, targs_change_title{k},'Interpreter','none');
		yticks(a{1},[0 0.5]);
		yticks(a{3},[0 50,100]);
		%%

		%%
		for j = 1:NUMd
			d_DA.Value = durDA(j);
			sd = run_sbiosimulate(model, species, targs_change{k}, mults{k});
			for i = 1:numel(targs_plot);
				[T, DATA] = obtain_profile(targs_plot{i}, sd, Toffset);
				plot(a{i}, T, DATA.*mult(i), '-', 'LineWidth', 1.5, 'Color', cols(j,:));
			end
		end
%		model.Parameters(14).Value = 100000;
		sd = run_sbiosimulate(model, species, targs_change{k}, mults{k});
		[io, idip] = Obtain_Io_Idip(sd, Toffset);
		fprintf('%s, Io: %g, Idip; %g\n', targs_change_title{k}, io, idip);

%		[AC1_disinhibitied_o, AC1_disinhibited_dip] = Obtain_AC1_disinhibited(sd, Toffset);
%		fprintf('%s, AC_disinhibitied_o: %g, AC1_disinhibited_dip; %g\n', ...
%			targs_change_title{k}, AC1_disinhibitied_o, AC1_disinhibited_dip );

		[Gi_GTPo, Gi_GTPdip] = Obtain_Gi_GTP(sd, Toffset);
		fprintf('%s, Gi_GTPo: %g uM, Gi_GTPdip; %g uM\n', targs_change_title{k}, Gi_GTPo, Gi_GTPdip);
	end
%%%

function [AC1_disinhibited_o, AC1_disinhibited_dip] = Obtain_AC1_disinhibited(sd, Toffset)
		AC1_disinhibited_o   = obtain_conc('AC1', sd, Toffset);
		AC1_disinhibited_dip = sd.Data(end, find( strcmp( sd.DataNames, 'AC1' )) );
end

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

