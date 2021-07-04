%
% flag_optoDA:  0, stepwise ; 1, opto dip; -1, opto burst
%
function container = stim_DA(model, flag_optoDA, Toffset_DA, duration_DA, stop_time);


	d_DA = addparameter(model, 'duration_DA'  , duration_DA);
	T_DA = addparameter(model, 'Toffset_DA'  , Toffset_DA);
	DA_dip   = addparameter(model, 'DA_dip'  , 0.05);
		
	container = containers.Map({'duration_DA', 'Toffset_DA', 'DA_dip'}, {d_DA, T_DA, DA_dip});

	%% Continuous DA
	if (flag_optoDA == 0)
		DA_basal = addparameter(model, 'DA_basal', 0.5);
		container('DA_basal') = DA_basal;

		e1   = addevent(model,'time>0'      				, 'DA = DA_basal' );
		e1   = addevent(model,'time>=Toffset_DA+0'      	, 'DA = DA_dip' );
		e1   = addevent(model,'time>=Toffset_DA+duration_DA', 'DA = DA_basal' );

	%% Opto DA
	elseif (flag_optoDA == 1)

		ReacEnzBasal('DA', 'DAT', 'None', 'Km_DAT', 'kcat_DAT', 'DA_dip', model);
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

	%% Opto DA burst (0.5 s, 20Hz)
	elseif (flag_optoDA == -1)

		%%
		%% DA burst (20 Hz, 10 times)
		%%

		ReacEnzBasal('DA', 'DAT', 'None', 'Km_DAT', 'kcat_DAT', 'DA_dip', model);
		id_DA_opto  = find(string({model.Parameters.Name}) == "DA_opto");
		container('DA_opto') = model.Parameters(id_DA_opto);

		%% Before

		t_optoDA = 0:-0.2:-Toffset_DA;
		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time>= %g + Toffset_DA', t_optoDA(i) );
			% display(condition_)
			action_    = 'DA = DA + DA_opto';
			addevent(model, condition_ , action_ );
		end

		%% DA burst (20 Hz, 10 times)

		t_optoDA = 0.05:0.05:duration_DA;
		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time>=%g + Toffset_DA', t_optoDA(i) );
			action_    = 'DA = DA + DA_opto';
			addevent(model, condition_ , action_ );
		end

		%% After

		% if flag_duration <= 0; continue; end;
		t_optoDA = 0.2:0.2:stop_time-(Toffset_DA+duration_DA);
		for i = 1:numel(t_optoDA);
			condition_ = sprintf('time>=%g + Toffset_DA + duration_DA', t_optoDA(i) );
			action_    = 'DA = DA + DA_opto';
			addevent(model, condition_ , action_ );
		end

	end
