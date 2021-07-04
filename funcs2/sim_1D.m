

function [ACprimed_basal, ACprimed_dip, t_half] = sim_1D( targ, mult_concs, species, model, Toffset)

	targ_output = 'ACprimed';
	num_concs  		= numel( mult_concs );
	ACact_basal_sim = zeros( num_concs,1 );
	ACact_dip_sim   = zeros( num_concs,1 );
	t_half_sim 		= zeros( num_concs,1 );

	reserv  = species{ targ,'Obj'}.InitialAmount;
	for j = 1:num_concs;
	%
		% Sim
		species{ targ,'Obj'}.InitialAmount = mult_concs(j) * reserv;
		sd   = sbiosimulate(model);

		% Get I and T
		ACprimed     = obtain_conc( targ_output, sd, Toffset);
		ACprimed_end = sd.Data(end, find( strcmp( sd.DataNames, targ_output )) );

		t_half(j) =  obtain_half( targ_output, sd, Toffset);

		ACprimed_basal(j) =  ACprimed;
		ACprimed_dip(j)   =  ACprimed_end;
	%
	end
	%

	species{ targ,'Obj'}.InitialAmount = reserv;

end

