

function [ACact_basal_sim, ACact_dip_sim, t_half_sim] = sim_1D( targ, mult_concs, species, model, Toffset)

	num_concs  		= numel( mult_concs );
	ACact_basal_sim = zeros( num_concs,1 );
	ACact_dip_sim   = zeros( num_concs,1 );
	t_half_sim 		= zeros( num_concs,1 );

	reserv = species{ targ,'Obj'}.InitialAmount;

	%
	for j = 1:num_concs;
	%
		% Sim
		species{ targ,'Obj'}.InitialAmount = mult_concs(j) * reserv;
		sd   = sbiosimulate(model);

		% Get I and T
		ACact    = obtain_conc('ACact', sd, Toffset);

		ACact_end = sd.Data(end, find( strcmp( sd.DataNames, 'ACact' )) );

		t_half_sim(j) =  obtain_half('ACact', sd, Toffset);

		ACact_basal_sim(j)     =  ACact;
		ACact_dip_sim(j)   =  ACact_end;
	%
	end
	%

	species{ targ,'Obj'}.InitialAmount = reserv;

end

