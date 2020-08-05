

%%%
%%%
%%%
function species_table = SetSpecies(species, model, compartment);

	inum = size(species);
	s = {};
	for i = 1:inum(1);
		% fprintf('%s\n', species{i,1});
		s{i} = addspecies(compartment, cell2mat(species{i,1}), species{i,2});
	end;
	s  = transpose(s);
	species_table  = cell2table(s, 'VariableNames', {'Obj'});
	species_table.Properties.RowNames = species{:,1};

