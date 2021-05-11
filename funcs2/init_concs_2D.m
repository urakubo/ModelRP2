%%
%%
%%

function init_concs = init_concs_2D( species, targ, conc, output_targs )

	nums = [numel(conc{1}), numel(conc{2})] ;


	num_output_targs = numel(output_targs);
	init_concs = cell(num_output_targs,1);
	for k = 1: num_output_targs;
		init_concs{k}  = zeros( nums );
	end

	reserv1 = species{targ{1},'Obj'}.InitialAmount;
	reserv2 = species{targ{2},'Obj'}.InitialAmount;

	for i = 1:nums(1);
		for j = 1:nums(2);
				species{targ{1},'Obj'}.InitialAmount = conc{1}(i) ;
				species{targ{2},'Obj'}.InitialAmount = conc{2}(j) ;

				for k = 1: num_output_targs;
					init_concs{k}(i,j)  = species{output_targs{k},'Obj'}.InitialAmount;
				end
		end
	end

	species{targ{1},'Obj'}.InitialAmount = reserv1;
	species{targ{2},'Obj'}.InitialAmount = reserv2;

end

