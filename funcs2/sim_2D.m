
function [ io_sim, idip_sim, t_half_sim ] = sim_2D(concs, targs, species, model, Toffset)

	nums = [numel(concs{1}), numel(concs{2})] ;
	t_half_sim  = zeros( nums );
	io_sim      = zeros( nums );
	idip_sim    = zeros( nums );

	reserv1 = species{targs{1},'Obj'}.InitialAmount;
	reserv2 = species{targs{2},'Obj'}.InitialAmount;
	fprintf('Target1: %s \n', targs{1});
	fprintf('Target2: %s \n', targs{2});
	fprintf('\n');

	for i = 1:nums(1);
		for j = 1:nums(2);
				species{targs{1},'Obj'}.InitialAmount = concs{1}(i) ;
				species{targs{2},'Obj'}.InitialAmount = concs{2}(j) ;
				
				sd   = sbiosimulate(model);
				
				%% time
				t_half_sim(i,j) = obtain_half('Gi_unbound_AC', sd, Toffset);
				
				%% Inhibition
				AC1tot = obtain_conc('AC1', sd, 0);
				AC1GTP = obtain_conc('AC1_Gi_GTP', sd, Toffset);
				AC1GDP = obtain_conc('AC1_Gi_GDP', sd, Toffset);

				AC1GTP_end = sd.Data(end, find( strcmp( sd.DataNames, 'AC1_Gi_GTP' )) );
				AC1GDP_end = sd.Data(end, find( strcmp( sd.DataNames, 'AC1_Gi_GDP' )) );

				AC1GTP = obtain_conc('AC1_Gi_GTP', sd, Toffset);
				AC1GDP = obtain_conc('AC1_Gi_GDP', sd, Toffset);

				io_sim(i,j)   = ( AC1GTP + AC1GDP )./AC1tot;
				idip_sim(i,j) = ( AC1GTP_end + AC1GDP_end )./AC1tot;
		end
	end

	species{targs{1},'Obj'}.InitialAmount = reserv1;
	species{targs{2},'Obj'}.InitialAmount = reserv2;

end

