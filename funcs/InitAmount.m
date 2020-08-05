
%%%
%%%
%%%
function InitAmount(name, amount, species, model);
	i = find(strcmp(species, name));
	model.Species(i).InitialAmount  = amount;



