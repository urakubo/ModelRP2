%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	font_init;

	data_dir = 'data';

	check = 0;
	[model, species, params, Toffset] = msn_setup(check);

%%%%
%%%% Simulation
%%%%

	FILENAME =  sprintf('%s/data.mat', data_dir);
	targs = {'RGS','AC1','D2R'};

	tmp = 10.^[-1:0.1:1];
	concs{1} 		= tmp;
	concs{2} 		= tmp;
	concs{3} 		= tmp;

	for i = 1:3;
		default_conc{i} = species{targs{i},'Obj'}.InitialAmount;
		concs{i} 		= concs{i} .* default_conc{i};
		fprintf('Original conc %s: %g uM \n', targs{i}, default_conc{i} );
	end

	nums = [numel(concs{1}), numel(concs{2}), numel(concs{3})] ;
	sd 		= cell( nums );
	t_half_simulation = zeros( nums );
	i_simulation      = zeros( nums );
	

	fprintf('\n');
	for i = 1:nums(1);
		fprintf('%s conc: %g uM \n', targs{1}, concs{1}(i));
		for j = 1:nums(2);
			% fprintf(' %s conc: %g uM \n', targs{2},  concs{2}(j));
			for k = 1:nums(3);
				species{targs{1},'Obj'}.InitialAmount = concs{1}(i) ;
				species{targs{2},'Obj'}.InitialAmount = concs{2}(j) ;
				species{targs{3},'Obj'}.InitialAmount = concs{3}(k) ;
				sd{i,j,k}   = sbiosimulate(model);
				
				%% time
				t_half_simulation(i,j,k) = obtain_half('Gi_unbound_AC', sd{i,j,k}, Toffset);
				
				%% Suppression
				AC1tot = obtain_conc('AC1', sd{i,j,k}, 0);
				AC1GTP = obtain_conc('AC1_Gi_GTP', sd{i,j,k}, Toffset);
				AC1GDP = obtain_conc('AC1_Gi_GDP', sd{i,j,k}, Toffset);
				i_simulation(i,j,k) = ( AC1GTP + AC1GDP )./AC1tot;
			end
		end
	end
	save(FILENAME);

