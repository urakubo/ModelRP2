%%
%% Please run this program before "main_3D_plot.m"
%%


	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	data_dir = 'data';
	TITLE = '3D';
	check = 0;
	[model, species, params, Toffset] = msn_setup(check);

%%%%
%%%% Simulation
%%%%

	FILENAME =  sprintf('%s/%s.mat', data_dir, TITLE);
	fprintf('\n');
	targs = {'RGS','AC1','D2R'};


	mult_concs = 10.^[-1:0.1:1];
	for i = 1:3;
		default_conc{i} = species{targs{i},'Obj'}.InitialAmount;
		concs{i} 		= mult_concs .* default_conc{i};
		fprintf('Original conc %s: %g uM \n', targs{i}, default_conc{i} );
	end


	nums = [numel(concs{1}), numel(concs{2}), numel(concs{3})] ;
	t_half_sim  = zeros( nums );
	io_sim      = zeros( nums );
	idip_sim    = zeros( nums );
	initial_concs = {zeros(nums), zeros(nums), zeros(nums)};

	fprintf('\n');
	for i = 1:nums(1);
		fprintf('%s conc: %g uM \n', targs{1}, concs{1}(i));
		for j = 1:nums(2);
			% fprintf(' %s conc: %g uM \n', targs{2},  concs{2}(j));
			for k = 1:nums(3);
				species{targs{1},'Obj'}.InitialAmount = concs{1}(i) ;
				species{targs{2},'Obj'}.InitialAmount = concs{2}(j) ;
				species{targs{3},'Obj'}.InitialAmount = concs{3}(k) ;
				initial_concs{1}(i,j,k) = concs{1}(i);
				initial_concs{2}(i,j,k) = concs{2}(j);
				initial_concs{3}(i,j,k) = concs{3}(k);
				
				sd   = sbiosimulate(model);
				
				%% time
				t_half_sim(i,j,k) = obtain_half('Gi_unbound_AC', sd, Toffset);
				
				%% Suppression
				AC1tot = obtain_conc('AC1', sd, 0);
				AC1GTP = obtain_conc('AC1_Gi_GTP', sd, Toffset);
				AC1GDP = obtain_conc('AC1_Gi_GDP', sd, Toffset);
				AC1GTP_end = sd.Data(end, find( strcmp( sd.DataNames, 'AC1_Gi_GTP' )) );
				AC1GDP_end = sd.Data(end, find( strcmp( sd.DataNames, 'AC1_Gi_GDP' )) );
				io_sim(i,j,k)   = ( AC1GTP + AC1GDP )./AC1tot;
				idip_sim(i,j,k) = ( AC1GTP_end + AC1GDP_end )./AC1tot;
			end
		end
	end


	save(FILENAME,'model','params','species','targs',...
		'mult_concs','default_conc','concs','nums', ...
		't_half_sim','io_sim','idip_sim',...
		'initial_concs');


