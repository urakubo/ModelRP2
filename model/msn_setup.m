
	%%
	%% MSN setup
	%%
function [model, species, params, Toffset] = msn_setup(check)

	stop_time 		= 3000;
	Toffset_DA   	= 100;
	Toffset   		= Toffset_DA;
	durDA = stop_time - Toffset_DA;

	DAbasal = 0.5;


	init_species = InitSpecies(DAbasal);
	init_params  = InitParams()
	[model, species, params] = DefineModel(init_species, init_params, stop_time);
	InitReacs(model, species, params, check);

	%%
	%% Simulation config
	%%
	configsetObj = getconfigset(model);
	set(configsetObj.SolverOptions, 'AbsoluteTolerance', 1.000000e-08);
	set(configsetObj.SolverOptions, 'RelativeTolerance', 1.000000e-05);

	%%
	%% Add event
	%%

	tDA     = addparameter(model, 'Toffset_DA'  , Toffset_DA);
	durDA   = addparameter(model, 'durDA'  , durDA);

	set(species{'DA_basal','Obj'}, 'ConstantAmount', false);
	set(species{'DA_basal','Obj'}, 'BoundaryCondition', true);


	e1   = addevent(model,'time>=Toffset_DA+0'      , 'DA = 0' );
	e1   = addevent(model,'time>=Toffset_DA+durDA'  , 'DA = DA_basal' );

	fprintf('\n');

