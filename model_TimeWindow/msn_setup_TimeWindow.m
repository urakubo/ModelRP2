%%
%% MSN setup
%%
function [model, species, params, container] = msn_setup_TimeWindow(flag_competitive, flag_duration, flag_optoDA)

	stop_time               = 50;
	Toffset_VGCC            = 10;
	Toffset_DA              = 10.8;
	flag_Gi_sequestrated_AC = 0;
	

	%%
	%% DA-dip duration
	%%
	if flag_duration < 0
		duration_DA = stop_time - Toffset_DA;
	else
		duration_DA = flag_duration;
	end

	%%
	%% Model definition
	%%
	species        = InitSpecies();
	InitAC = species{'AC1','Conc'};
	species_Ca_PKA = InitSpecies_Ca_PKA(1);
	init_species   = [species; species_Ca_PKA];

	params         = InitParams();
	params_Ca_PKA  = InitParams_Ca_PKA();
	init_params    = [params; params_Ca_PKA];

	[model, species, params] = DefineModel(init_species, init_params, stop_time);
	InitReacs(model, species, params, flag_competitive, flag_Gi_sequestrated_AC);
	InitReacs_Ca_PKA(model, species, params);

	%%
	%% Config
	%%
	configsetObj = getconfigset(model);
	% configsetObj.SolverType = 'ode45';
	set(configsetObj.SolverOptions, 'AbsoluteTolerance', 1.000000e-08);
	set(configsetObj.SolverOptions, 'RelativeTolerance', 1.000000e-05);


	%%
	%% Event
	%%
	container_VGCC = stim_VGCC(model, Toffset_VGCC);
	container_DA   = stim_DA(model, flag_optoDA, Toffset_DA, duration_DA, stop_time);
	container = [container_DA; container_VGCC];

	fprintf('\nModel generated\n\n');

