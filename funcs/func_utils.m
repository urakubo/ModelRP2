
%%%
%%%
%%%
function  [model, species] = DefineModel(species_init, stop_time);

	if nargin==1;
		stop_time = 100;
	end

	model        = sbiomodel('Test enz');
	compartment  = addcompartment(model,'Cell body');
	configObj = getconfigset(model);
	set(configObj, 'StopTime', stop_time);
	species = SetSpecies(species_init, model, compartment);



%%%
%%%
%%%
function species_table = SetSpecies(species, model, compartment);

	inum = size(species);
	s = {};
	for i = 1:inum(1);
		s{i} = addspecies(compartment, species{i,1}, species{i,2});
	end;
	s  = transpose(s);
	species_table  = cell2table(s, 'VariableNames', {'Obj'});
	species_table.Properties.RowNames = species(:,1);


%%%
%%%
%%%
function species_obj = SetSpeciesName(species_name, species_amount, model, compartment);

	%species_obj  = {};
	for i = 1:numel(species_name);
		species_obj = addspecies(compartment, species_name{i});
		species_obj.InitialAmount  = species_amount(i);
	end;



