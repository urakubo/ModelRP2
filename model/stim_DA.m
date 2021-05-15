%%
%%
function container = stim_DA(model, flag_optoDA, Toffset_DA, duration_DA, stop_time);
%%
%%
	d_DA = addparameter(model, 'duration_DA'  , duration_DA);
	T_DA = addparameter(model, 'Toffset_DA'  , Toffset_DA);
	container = containers.Map({'duration_DA', 'Toffset_DA'}, {d_DA, T_DA});

	%% Continuous DA
	if (flag_optoDA == 0)
		DA_basal = addparameter(model, 'DA_basal', 0.5);
		DA_dip   = addparameter(model, 'DA_dip'  , 0.05);
		container('DA_basal') = DA_basal;
		container('DA_dip')   = DA_dip;
		e1   = addevent(model,'time>0'      				, 'DA = DA_basal' );
		e1   = addevent(model,'time>=Toffset_DA+0'      	, 'DA = DA_dip' );
		e1   = addevent(model,'time>=Toffset_DA+duration_DA', 'DA = DA_basal' );

	%% Opto DA
	else
		ReacEnz('DA', 'DAT', 'None', 'Km_DAT', 'kcat_DAT', model);
		id_DA_opto  = find(string({model.Parameters.Name}) == "DA_opto");
		container('DA_opto') = model.Parameters(id_DA_opto);

		t_optoDA = 0:-0.2:-Toffset_DA;
		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time>= %g + Toffset_DA', t_optoDA(i) );
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
