%%
%%
%%

function InitReacs(model, species, params, check); % TYPE : D1 or D2

	%%
	%% DA decrease
	%%
%	eid = Reac11('DA', 'DA_basal'	, 'kdec_DA', 'kinc_DA', model);
%	eid = Reac11('DA', 'BuffDA'		, 'kon_DA_BuffDA', 'koff_DA_BuffDA', model);

	set(species{'DA','Obj'}, 'ConstantAmount', false);
	set(species{'DA','Obj'}, 'BoundaryCondition', true);

	%%
	%% DA-D2R binding => Gi
	%%
	% eid = Reac21('DA', 'D2R', 'DA_D2R'					, 'kf_DA_D2R', 'kb_DA_D2R', model);
	eid = ReacChannel('D2R', 'DA','DA_D2R'	,  'kf_DA_D2R' ,  model);
	eid = ReacOneWay('DA_D2R', 'D2R' 		,  'kb_DA_D2R',	model);

	%% Ga_Gb dissoci associ
	eid = ReacChannel('Gi_GDP', 'Gbc', 'Gi_Gbc'		, 'kon_Gbc_Gi'		, model);
	eid = ReacEnz('Gi_Gbc', 'DA_D2R', 'Gi_GTP'		, 'Km_exch_Gi', 'kcat_exch_Gi', model); % Gi_Gbc -> DA_D2R -> Gi_GTP + Gbr (buffered)

	%% Golf_GTP binding to AC
	if (check == 0)
		eid = Reac21('Gi_GTP', 'AC1', 'AC1_Gi_GTP'		, 'kon_AC_GiGTP'  , 'koff_AC_GiGTP', model);
		eid = Reac12('AC1_Gi_GDP'   , 'AC1' , 'Gi_GDP'	, 'koff_AC_GiGDP' , 'kon_AC_GiGDP', model);
	else
		eid = ReacChannel('AC1', 'Gi_GTP', 'AC1_Gi_GTP'	, 'kon_AC_GiGTP' ,  model);
		eid = ReacOneWay('AC1_Gi_GTP', 'AC1'			, 'koff_AC_GiGTP',	model);
		eid = ReacChannel('AC1', 'Gi_GDP', 'AC1_Gi_GDP'	, 'kon_AC_GiGDP' ,  model);
		eid = ReacOneWay('AC1_Gi_GDP', 'AC1'			, 'koff_AC_GiGDP',	model);
	end


	%% Hydro1, Hydro2
	eid = ReacEnz('Gi_GTP', 'RGS', 'Gi_GDP'					, 'Km_hyd_Gi' , 'kcat_hyd_Gi' , model);
	eid = ReacEnz('AC1_Gi_GTP', 'RGS', 'AC1_Gi_GDP'			, 'Km_hyd_Gi' , 'kcat_hyd_Gi' , model);


	%% Constant species
	set(species{'DA_basal','Obj'}, 'ConstantAmount', true);

	%%
	%% AC1
	%%
	r = addrule(model,'Gi_unbound_AC  = AC1', 'repeatedAssignment');
	r = addrule(model,'AllGi = Gi_Gbc + Gi_GTP + Gi_GDP + AC1_Gi_GTP + AC1_Gi_GDP', 'repeatedAssignment');


