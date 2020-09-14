

function [t_sim, i_sim] = sim_1D( targ, mult_concs, species, model, Toffset)

	num_concs = numel( mult_concs );
	t_sim     = zeros( num_concs,1 );
	i_sim     = zeros( num_concs,1 );

	reserv = species{ targ,'Obj'}.InitialAmount;

	for j = 1:num_concs;
	% Sim
		species{ targ,'Obj'}.InitialAmount = mult_concs(j) * reserv;
		sd   = sbiosimulate(model);

	% Get I and T
		AC1tot = obtain_conc('AC1', sd, 0);
		AC1GTP = obtain_conc('AC1_Gi_GTP', sd, Toffset);
		AC1GDP = obtain_conc('AC1_Gi_GDP', sd, Toffset);
		t_sim(j) =  obtain_half('Gi_unbound_AC', sd, Toffset);
		i_sim(j) =  ( AC1GTP + AC1GDP )./AC1tot;
	end
	
	species{ targ,'Obj'}.InitialAmount = reserv;

end

