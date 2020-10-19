%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	data_dir = 'data';
	TITLE = '2D';

	init_font;

	check = 0;
%	check = 1;
	[model, species, params, Toffset] = msn_setup(check);
	% check == 0: normal; 
	% check != 1 AC1 binding do not affect Gi conc.

%%%
%%%

	fprintf('\n');
	targs = {'D2R','AC1','RGS'};


	tmp = 10.^[-1:0.025:1];
%	tmp = 10.^[-1:0.1:1];

	for i = 1:3;
		mult_concs{i}	= tmp;
		default_conc	= species{targs{i},'Obj'}.InitialAmount;
		concs{i}		= mult_concs{i} .* default_conc;
		fprintf('Standard conc %s: %g uM \n', targs{i}, default_conc );
	end


%%
%% 2D plot
%%

	dims = { [3,1], [2,1], [2,3] };
%	dims = { [3,1] };

	for  i = 1:numel(dims);

		mconc = mult_concs(dims{i});
		conc = concs(dims{i});
		targ = targs(dims{i});

		% Simulation
		[io_sim, idip_sim, t_half_sim] = sim_2D(conc, targ, species, model, Toffset);

		% Theory
		D2R_AC1_RGS = obtain_init_concs_2D(species, targ, conc, targs);
		[ io_theory, idip_theory, t_half_theory ] = theory(D2R_AC1_RGS{1}, D2R_AC1_RGS{2}, D2R_AC1_RGS{3}, params);


		FILENAME =  sprintf('%s/%s_%g_%g.mat', data_dir, TITLE, dims{i}(1), dims{i}(2));
		save(FILENAME,'model','params','species',...
			'mconc','conc','targ', ...
			't_half_sim','io_sim','idip_sim',...
			'io_theory', 'idip_theory', 't_half_theory');

	end



