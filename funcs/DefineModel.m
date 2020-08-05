
%%%
%%%
%%%
function  [model, species, params] = DefineModel(init_species, init_params, stop_time);

	if nargin==2;
		stop_time = 100;
	end

	model        = sbiomodel('Test enz');
	compartment  = addcompartment(model,'Cell body');
	configObj = getconfigset(model);
	set(configObj, 'StopTime', stop_time);

	params  = SetParams(init_params, model);
	species = SetSpecies(init_species, model, compartment);




