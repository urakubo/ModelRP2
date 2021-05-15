%%
%% MSN setup
%%
function [model, species, params, container] = msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration, varargin)

%	fprintf('nargin: %g\n',nargin);
%	fprintf('varargin{1}: %g\n',varargin{1});
%	fprintf('varargin{2}: %g\n',varargin{2});
	if nargin == 5
	    stop_time = varargin;
	    Toffset_DA = 100;
	elseif nargin == 6
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
	fprintf('\nModel generated\n\n');


%%
%%
function container = stim_DA(model, flag_optoDA, Toffset_DA, duration_DA, stop_time);
%%
%%
	d_DA = addparameter(model, 'duration_DA'  , duration_DA);
	T_DA  = addparameter(model, 'Toffset_DA'  , Toffset_DA);
	container = containers.Map({'duration_DA', 'Toffset_DA'}, {d_DA, T_DA});

	%% Continuous DA
	if (flag_optoDA == 0)
		DA_basal = addparameter(model, 'DA_basal', 0.5);
		DA_dip   = addparameter(model, 'DA_dip'  , 0.05);
		container('DA_basal') = DA_basal;
		container('DA_dip')   = DA_dip;
		e1   = addevent(model,'time>0'      			, 'DA = DA_basal' );
		e1   = addevent(model,'time>=Toffset_DA+0'      , 'DA = DA_dip' );
		e1   = addevent(model,'time>=Toffset_DA+duration_DA'  , 'DA = DA_basal' );

	%% Opto DA
	else
		ReacEnz('DA', 'DAT', 'None', 'Km_DAT', 'kcat_DAT', model);
		DA_opto = addparameter(model, 'DA_opto', 0.55884);
		container('DA_opto') = DA_opto;
		t_optoDA = 0:0.2:Toffset_DA;

		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time>= %g', t_optoDA(i) );
			% display(condition_)
			action_    = 'DA = DA + DA_opto';
			addevent(model, condition_ , action_ );
		end

		% if flag_duration <= 0; continue; end;
		t_optoDA = 0:0.2:stop_time-(Toffset_DA+duration_DA);
		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time>=%g + Toffset_DA + duration_DA', t_optoDA(i) );
			action_    = 'DA = DA + DA_opto';
			addevent(model, condition_ , action_ );
		end
	end
