

function [io_sim, idip_sim, t_half_sim] = sim_1D( targ, mult_concs, species, model, Toffset)

	num_concs  = numel( mult_concs );
	io_sim     = zeros( num_concs,1 );
	idip_sim   = zeros( num_concs,1 );
	t_half_sim = zeros( num_concs,1 );

	reserv = species{ targ,'Obj'}.InitialAmount;

	for j = 1:num_concs;
	% Sim
		species{ targ,'Obj'}.InitialAmount = mult_concs(j) * reserv;
		sd   = sbiosimulate(model);

	% Get I and T
		AC1tot = obtain_conc('AC1', sd, 0);
		AC1GTP = obtain_conc('AC1_Gi_GTP', sd, Toffset);
		AC1GDP = obtain_conc('AC1_Gi_GDP', sd, Toffset);
		AC1GTP_end = sd.Data(end, find( strcmp( sd.DataNames, 'AC1_Gi_GTP' )) );
		AC1GDP_end = sd.Data(end, find( strcmp( sd.DataNames, 'AC1_Gi_GDP' )) );
		
		t_half_sim(j) =  obtain_half('Gi_unbound_AC', sd, Toffset);
		io_sim(j)     =  ( AC1GTP + AC1GDP )./AC1tot;
		idip_sim(j)   =  ( AC1GTP_end + AC1GDP_end )./AC1tot;
	end
	
	species{ targ,'Obj'}.InitialAmount = reserv;

end

