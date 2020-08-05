
%%%
%%%
%%%
function InitAmounts(species_int, species, model);

	for i = 1:numel(species_int{:,1})
		% fprintf('%s\n', species_int{i,1});
		% species{species_int{i,1},'Obj'}
		species{cell2mat(species_int{i,1}),'Obj'}.InitialAmount = species_int{i,2};
	end;

