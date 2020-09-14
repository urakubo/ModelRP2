
function [ sd, i_simulation, t_half_simulation ] = sim_2D(concs, targs, species, model, Toffset)

	nums = [numel(concs{1}), numel(concs{2})] ;
	sd 		= cell( nums );
	t_half_simulation = zeros( nums );
	i_simulation      = zeros( nums );

	reserv1 = species{targs{1},'Obj'}.InitialAmount;
	reserv2 = species{targs{2},'Obj'}.InitialAmount;
	fprintf('Target1: %s \n', targs{1});
	fprintf('Target2: %s \n', targs{2});
	fprintf('\n');

	for i = 1:nums(1);
		for j = 1:nums(2);
				species{targs{1},'Obj'}.InitialAmount = concs{1}(i) ;
				species{targs{2},'Obj'}.InitialAmount = concs{2}(j) ;
				sd{i,j}   = sbiosimulate(model);
				
				%% time
				t_half_simulation(i,j) = obtain_half('Gi_unbound_AC', sd{i,j}, Toffset);
				
				%% Inhibition
				AC1tot = obtain_conc('AC1', sd{i,j}, 0);
				AC1GTP = obtain_conc('AC1_Gi_GTP', sd{i,j}, Toffset);
				AC1GDP = obtain_conc('AC1_Gi_GDP', sd{i,j}, Toffset);
				i_simulation(i,j) = ( AC1GTP + AC1GDP )./AC1tot;
		end
	end

	species{targs{1},'Obj'}.InitialAmount = reserv1;
	species{targs{2},'Obj'}.InitialAmount = reserv2;

end

