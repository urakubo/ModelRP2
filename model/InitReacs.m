%%
%%
%%

function InitReacs(model, species, params, flag_competitive, flag_Gi_sequestrated_AC); %

	%%
	%% DA-D2R binding
	%%
	set(species{'DA','Obj'}, 'ConstantAmount', false);
	set(species{'DA','Obj'}, 'BoundaryCondition', false);
	% eid = Reac21('DA', 'D2R', 'DA_D2R'	, 'kf_DA_D2R', 'kb_DA_D2R', model);
	eid = ReacChannel('D2R', 'DA','DA_D2R'	,  'kf_DA_D2R' ,  model);
	eid = ReacOneWay('DA_D2R', 'D2R' 		,  'kb_DA_D2R',	model);


	%%
	%% D2R => Gi
	%%

	%% Ga_Gb dissoci associ
	eid = ReacChannel('Gi_GDP', 'Gbc', 'Gi_Gbc'		, 'kon_Gbc_Gi'		, model);
	eid = ReacEnz('Gi_Gbc', 'DA_D2R', 'Gi_GTP'		, 'Km_exch_Gi', 'kcat_exch_Gi', model);
	% Gi_Gbc -> DA_D2R -> Gi_GTP + Gbr (buffered)

	%% Hydro1, Hydro2
	eid = ReacEnz('Gi_GTP', 'RGS', 'Gi_GDP'					, 'Km_hyd_Gi' , 'kcat_hyd_Gi' , model);
	eid = ReacEnz('AC1_Gi_GTP', 'RGS', 'AC1_Gi_GDP'			, 'Km_hyd_Gi' , 'kcat_hyd_Gi' , model);

	%% Gi_GTP binding to AC
	if (flag_Gi_sequestrated_AC == 0)
		eid = ReacChannel('AC1', 'Gi_GTP', 'AC1_Gi_GTP'	, 'kon_AC_GiGTP' ,  model);
		eid = ReacOneWay('AC1_Gi_GTP', 'AC1'			, 'koff_AC_GiGTP',	model);
		eid = ReacChannel('AC1', 'Gi_GDP', 'AC1_Gi_GDP'	, 'kon_AC_GiGDP' ,  model);
		eid = ReacOneWay('AC1_Gi_GDP', 'AC1'			, 'koff_AC_GiGDP',	model);
	else
		eid = Reac21('Gi_GTP', 'AC1', 'AC1_Gi_GTP'		, 'kon_AC_GiGTP'  , 'koff_AC_GiGTP', model);
		eid = Reac12('AC1_Gi_GDP'   , 'AC1' , 'Gi_GDP'	, 'koff_AC_GiGDP' , 'kon_AC_GiGDP', model);
	end

	%% Golf binding to AC
	set(species{'Golf','Obj'}, 'ConstantAmount', true);
	set(species{'Golf','Obj'}, 'BoundaryCondition', true);
	r = addrule(model,'Golf_bound  = Golf ./ ((koff_AC_GolfGTP / kon_AC_GolfGTP) + Golf)', 'repeatedAssignment');

	if (flag_competitive == 0)
		ReacChannel('AC2','Golf', 'Golf_AC2', 'kon_AC_GolfGTP' , model);
		ReacOneWay( 'Golf_AC2'	, 'AC2'		, 'koff_AC_GolfGTP', model);
		r = addrule(model,'AC1tot = AC1 + AC1_Gi_GTP + AC1_Gi_GDP ', 'repeatedAssignment');
		r = addrule(model,'ACact  = Golf_AC2 * AC1 / AC1tot / Golf_bound', 'repeatedAssignment');
	else
		ReacChannel('AC1','Golf', 'Golf_AC1', 'kon_AC_GolfGTP' , model);
		ReacOneWay( 'Golf_AC1'	, 'AC1'		, 'koff_AC_GolfGTP', model);	
		r = addrule(model,'ACtot    = Golf_AC1 + AC1 + AC1_Gi_GTP + AC1_Gi_GDP', 'repeatedAssignment');
		r = addrule(model,'ACact    = Golf_AC1 / ACtot / Golf_bound', 'repeatedAssignment');
	end



