%%
%% MSN setup
%%
function [model, species, params, container] = msn_setup_TimeWindow_AC5_DA_Golf(flag_competitive, flag_duration, flag_optoDA)

	stop_time               = 50;
	Toffset_Golf            = 20;
	Toffset_DA              = 20.0;
	flag_Gi_sequestrated_AC = 1;
	duration_Golf           = 1.0;

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
	species               = InitSpecies();
	species('ActiveAC',:) = {{'ActiveAC'}, 0};
	params                = InitParams();
	[model, species, params] = DefineModel(species, params, stop_time);
	InitReacs(model, species, params, flag_competitive, flag_Gi_sequestrated_AC);

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
	container_Golf = stim_Golf(model, Toffset_Golf, duration_Golf);
	container_DA   = stim_DA(model, flag_optoDA, Toffset_DA, duration_DA, stop_time);
	container = [container_DA; container_Golf];


	%%
	%% Add reactions
	%%
	if (flag_competitive == 0)
		r = addrule(model,'ActiveAC = Golf_AC2 * AC1 / AC1tot', 'repeatedAssignment');
	else
		r = addrule(model,'ActiveAC = Golf_AC1 / ACtot', 'repeatedAssignment');
	end
	fprintf('\nModel generated\n\n');


