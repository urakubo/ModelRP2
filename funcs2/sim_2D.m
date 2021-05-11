
function [ AC_basal_sim, AC_dip_sim, t_half_sim ] = sim_2D(concs, targs, species, model, Toffset)

	nums = [numel(concs{1}), numel(concs{2})] ;
	t_half_sim  = zeros( nums );
	AC_basal_sim  = zeros( nums );
	AC_dip_sim    = zeros( nums );

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
				t_half_sim(i,j) = obtain_half('ACact', sd, Toffset);
				
				%%
				AC1tot   = obtain_conc('AC1', sd, 0);
				ACact    = obtain_conc('ACact', sd, Toffset);
				ACact_end = sd.Data(end, find( strcmp( sd.DataNames, 'ACact' )) );

				AC_basal_sim(i,j)  = ACact;
				AC_dip_sim(i,j)    = ACact_end;
		end
	end

	species{targs{1},'Obj'}.InitialAmount = reserv1;
	species{targs{2},'Obj'}.InitialAmount = reserv2;

end

