

%%%
%%%
%%%
function species_obj = SetSpeciesName(species_name, species_amount, model, compartment);

	%species_obj  = {};
	for i = 1:numel(species_name);
		species_obj = addspecies(compartment, species_name{i});
		species_obj.InitialAmount  = species_amount(i);
	end;




