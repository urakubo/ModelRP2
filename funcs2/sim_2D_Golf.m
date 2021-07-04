
function [ AC_basal, AC_dip, t_half ] = sim_2D_Golf(mults, targs, species, params, model, Toffset)


	nums = [numel(concs{1}), numel(concs{2})] ;
	t_half    = zeros( nums );
	AC_basal  = zeros( nums );
	AC_dip    = zeros( nums );
	targ_output = 'ACprimed';


	%%
	reserv = {}
	for k = 1:2;
		if strcmp(targs{k}, 'tau_Golf')
			reserv{k} = [ params{'kon_AC_Golf' ,'Obj'}.Value, params{'koff_AC_Golf' ,'Obj'}.Value ];
		else
			reserv{k} = species{targs{k},'Obj'}.InitialAmount;
		end
	end
	%%
	fprintf('Target1: %s \n', targs{1});
	fprintf('Target2: %s \n', targs{2});
	fprintf('\n');
	%%

	for i = 1:nums(1);
		for j = 1:nums(2);

				%%
				for k = 1:2;
					if strcmp(targs{k}, 'tau_Golf')
						params{'kon_AC_Golf' ,'Obj'}.Value  = reserv{k}(1) / mults{k}(i);
						params{'koff_AC_Golf' ,'Obj'}.Value = reserv{k}(2) / mults{k}(i);
					else
						species{targs{k},'Obj'}.InitialAmount = reserv{k} * mults{k}(i) ;
					end
				end
				%%
				sd   = sbiosimulate(model);	
				%% time
				t_half_sim(i,j) = obtain_half('ACact', sd, Toffset);
				
				%%
				AC1tot       = obtain_conc('AC1'      , sd, 0       );
				ACprimed     = obtain_conc(targ_output, sd, Toffset );
				ACprimed_end = sd.Data(end, find( strcmp( sd.DataNames, targ_output )) );

				AC_basal(i,j)  = ACprimed;
				AC_dip(i,j)    = ACprimed_end;
				%%
		end
	end

end



