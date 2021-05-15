%%
%% MSN setup
%%
function [model, species, params, container] = msn_one_opto(DAvarargin)

	if nargin == 1
	    stop_time = varargin;
	    Toffset_DA = 100;
	elseif nargin == 2
	    stop_time  = varargin{1};
	    Toffset_DA = varargin{2};
	else
	    stop_time  = 3000;
	    Toffset_DA = 100;
	end
	
	%% Setting DA-dip duration
	if flag_duration < 0
		duration_DA = stop_time - Toffset_DA;
	else
		duration_DA = flag_duration;
	end

	init_species = InitSpecies();
	init_params  = InitParams()
	[model, species, params] = DefineModel(init_species, init_params, stop_time);
	InitReacs(model, species, params, flag_competitive, flag_Gi_sequestrated_AC);

	%%
	%% Simulation config
	%%
	configsetObj = getconfigset(model);
	% configsetObj.SolverType = 'ode45';
	set(configsetObj.SolverOptions, 'AbsoluteTolerance', 1.000000e-08);
	set(configsetObj.SolverOptions, 'RelativeTolerance', 1.000000e-05);

	%%
	%% Add event
	%%
	container = stim_DA(model, flag_optoDA, Toffset_DA, duration_DA, stop_time);

	ReacEnz('DA', 'DAT', 'None', 'Km_DAT', 'kcat_DAT', model);
	DA_opto = addparameter(model, 'DA_opto', 0.55884);
	container = containers.Map({'DA_opto'}, {DA_opto});


	addevent(model, 'time>=Toffset_DA' , 'DA = DA + DA_opto' );

	fprintf('\nModel generated\n\n');



