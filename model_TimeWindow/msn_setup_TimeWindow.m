%%
%% MSN setup
%%
function [model, species, params, T_VGCC, T_DA] = msn_setup_TimeWindow(flag_competitive, flag_duration, flag_optoDA)

	stop_time               = 50;
	Toffset_DA              = 10;
	Toffset_VGCC            = Toffset_DA;
	flag_Gi_sequestrated_AC = 0;
	

	%%
	%% DA-dip duration
	%%
	if flag_duration < 0
		durDA = stop_time - Toffset_DA;
	else
		durDA = flag_duration;
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
	T_VGCC = stim_VGCC(model, Toffset_VGCC);
	T_DA   = stim_DA(model, flag_optoDA, Toffset_DA, durDA, stop_time);

	fprintf('\nModel generated\n\n');

%%
%%
function T_VGCC = stim_VGCC(model, Toffset_VGCC);
%%
%%
	addparameter(model, 'VGCCplus', 0.55884);

	T_VGCC = addparameter(model, 'Toffset_VGCC'  , Toffset_VGCC);
	e1 = addevent(model,'time>=Toffset_VGCC'		,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.1'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.2'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.3'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.4'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.5'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.6'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.7'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.8'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.9'	,'VGCC = VGCC + VGCCplus');

%%
%%
function T_DA = stim_DA(model, flag_optoDA, Toffset_DA, durDA, stop_time);
%%
%%
	addparameter(model, 'durDA'  , durDA);
	T_DA = addparameter(model, 'Toffset_DA'  , Toffset_DA);

	%% Continuous DA
	if (flag_optoDA == 0)
		addparameter(model, 'DA_basal', 0.5);
		addparameter(model, 'DA_dip'  , 0.05);
		addevent(model,'time>0'      			 , 'DA = DA_basal' );

		addevent(model,'time>=Toffset_DA+0'      , 'DA = DA_dip'   );
		addevent(model,'time>=Toffset_DA+durDA'  , 'DA = DA_basal' );

	%% Opto DA
	else
		ReacEnz('DA', 'DAT', 'None', 'Km_DAT', 'kcat_DAT', model);

		t_optoDA = 0:0.2:Toffset_DA;

		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time > Toffset_DA - %g', t_optoDA(i) );
			action_    = 'DA = DA + DA_opto';
			addevent(model, condition_ , action_ );
		end

		t_optoDA = 0:0.2:stop_time-(Toffset_DA+durDA);
		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time > %g + Toffset_DA + durDA', t_optoDA(i) );
			action_    = 'DA = DA + DA_opto';
			addevent(model, condition_ , action_ );
		end
	end


