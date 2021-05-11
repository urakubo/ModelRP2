%%
%% MSN setup
%%
function [model, species, params, Toffset_DA] = msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration, varargin)

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
		durDA = stop_time - Toffset_DA;
	else
		durDA = flag_duration;
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
	addparameter(model, 'durDA'  , durDA);
	addparameter(model, 'Toffset_DA'  , Toffset_DA);

	%% Continuous DA
	if (flag_optoDA == 0)
		DA_basal = addparameter(model, 'DA_basal', 0.5);
		DA_dip   = addparameter(model, 'DA_dip'  , 0.05);
		e1   = addevent(model,'time>0'      			, 'DA = DA_basal' );
		e1   = addevent(model,'time>=Toffset_DA+0'      , 'DA = DA_dip' );
		e1   = addevent(model,'time>=Toffset_DA+durDA'  , 'DA = DA_basal' );

	%% Continuous DA
	else
		ReacEnz('DA', 'DAT', 'None', 'Km_DAT', 'kcat_DAT', model);
		iDA     = addparameter(model, 'iDA', 0.55884);
		t_optoDA = 0:0.2:Toffset_DA;

		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time>= %g', t_optoDA(i) );
			% display(condition_)
			action_    = 'DA = DA + iDA';
			addevent(model, condition_ , action_ );
		end

		% if flag_duration <= 0; continue; end;
		t_optoDA = 0:0.2:stop_time-(Toffset_DA+durDA);
		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time>=%g + Toffset_DA + durDA', t_optoDA(i) );
			action_    = 'DA = DA + iDA';
			addevent(model, condition_ , action_ );
		end
	end

	fprintf('Model generated\n');

