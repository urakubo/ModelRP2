%%
%%
%%

function InitReacs_Ca_PKA(model, species, params); %

	%% cAMP production -> degradation
	eid = ReacEnz('ATP', 'ActiveAC', 'cAMP'					, 'Km_AC', 'kcat_AC', model);
	eid = ReacEnz('cAMP', 'PDE', 'AMP'						, 'Km_PDE', 'kcat_PDE', model);

	%%
	%% PKA_cAMP associ
	%%
	eid = Reac21('R2C2', 		'cAMP', 'R2C2cAMP'  		, 'kon_A'	 , '_16koff_A', model);
	eid = Reac21('R2C2cAMP', 	'cAMP', 'R2C2cAMP2' 		, 'kon_A'	 , '_4koff_A', model);
	eid = Reac21('R2C2cAMP2',   'cAMP', 'R2C2cAMP3'  		, '_4kon_A' , 'koff_A', model);
	eid = Reac21('R2C2cAMP3', 	'cAMP', 'R2C2cAMP4' 		, '_16kon_A' , 'koff_A', model);

	eid = Reac12('R2C2cAMP4',   'Ct', 'R2C1cAMP4'  			, '_2koff_C'	, 'kon_C', model);
	eid = Reac12('R2C1cAMP4', 	'Ct', 'R2C0cAMP4' 			, 'koff_C'	, '_2kon_C', model);


	%% Ca-CB binding
	eid = Reac21( 'CB'  ,'Ca', 'Ca_CB' 						, 'kon_CB'	, 'koff_CB', model);

	%% Ca uptake
	eid = ReacChannel('Ca', 'CaPump', 'Ca_ext'				, 'kpump_Ca'		, model);
	
	%% Ca influx 
	eid = ReacChannel('Ca_ext', 'VGCC', 'Ca'		, 'kinflux_Ca'		, model);
	eid = ReacOneWay('VGCC', 'VGCC_dummy'			, 'kdeact_VGCC'		, model);

	%% Constant species
	set(species{'ATP','Obj'}, 'ConstantAmount', true);
%	set(species{'DA_basal','Obj'}, 'ConstantAmount', true);
	set(species{'Ca_ext','Obj'}, 'ConstantAmount', true);
	set(species{'VGCC_dummy','Obj'}, 'ConstantAmount', true);


	%%
	%% AC1-CaCaM interaction
	%%
	CaM_AC_Reacs(model, species, params)
	tmp = 'AC_CaM = AC3_N0C0 + AC3_N0C1 + AC3_N0C2 + AC3_N1C0 + AC3_N1C1 + AC3_N1C2 + AC3_N2C0 + AC3_N2C1 + AC3_N2C2';
	tmp = 'AC_CaM = (AC3_N0C0 + AC3_N0C1 + AC3_N0C2 + AC3_N1C0 + AC3_N1C1 + AC3_N1C2 + AC3_N2C0 + AC3_N2C1 + AC3_N2C2)/ACsub_CaM';
	r = addrule(model, tmp,'repeatedAssignment');


	%%
	%% Active AC1 interaction
	%%
	% r = addrule(model,'ActiveAC = ACact * AC_CaM + BasalAC','repeatedAssignment');
	% r = addrule(model,'ActiveAC = 0.99 * ACact * AC_CaM + 0.01 * ACact','repeatedAssignment');
	r = addrule(model,'ActiveAC = ACact * AC_CaM','repeatedAssignment');


%%%
%%%
%%%

function CaM_AC_Reacs(model, species, params)

	%% Ca-CaM binding
	eid = Reac21('N0C0' ,'Ca', 'N1C0'  	, '_2kon_T_N'	, 'koff_T_N', model);
	eid = Reac21('N1C0' ,'Ca', 'N2C0'  	, 'kon_R_N'		, '_2koff_R_N', model);
	eid = Reac21('N0C0' ,'Ca', 'N0C1'  	, '_2kon_T_C'	, 'koff_T_C', model);
	eid = Reac21('N0C1' ,'Ca', 'N0C2'  	, 'kon_R_C'		, '_2koff_R_C', model);
	eid = Reac21('N1C0' ,'Ca', 'N1C1'  	, '_2kon_T_C'	, 'koff_T_C', model);
	eid = Reac21('N0C1' ,'Ca', 'N1C1'  	, '_2kon_T_N'	, 'koff_T_N', model);
	eid = Reac21('N1C1' ,'Ca', 'N2C1'  	, 'kon_R_N'		, '_2koff_R_N', model);
	eid = Reac21('N1C1' ,'Ca', 'N1C2'  	, 'kon_R_C'		, '_2koff_R_C', model);
	eid = Reac21('N0C2' ,'Ca', 'N1C2'  	, '_2kon_T_N'	, 'koff_T_N', model);
	eid = Reac21('N2C0' ,'Ca', 'N2C1'  	, '_2kon_T_C'	, 'koff_T_C', model);
	eid = Reac21('N1C2' ,'Ca', 'N2C2'  	, 'kon_R_N'		, '_2koff_R_N', model);
	eid = Reac21('N2C1' ,'Ca', 'N2C2'  	, 'kon_R_C'		, '_2koff_R_C', model);

	%% 
	%% Ca/CaM + AC <=> AC-CaM binding state 1 (AC1)
	%%
	eid = Reac21('N0C0' ,'ACsub3', 'AC1_N0C0'  	, 'kon_AC_CaM_g_b2_b1', 'koff_AC_CaM', model);
	eid = Reac21('N0C1' ,'ACsub3', 'AC1_N0C1'  	, 'kon_AC_CaM_g_b2'   , 'koff_AC_CaM', model);
	eid = Reac21('N0C2' ,'ACsub3', 'AC1_N0C2'  	, 'kon_AC_CaM_g'      , 'koff_AC_CaM', model);
	
	eid = Reac21('N1C0' ,'ACsub3', 'AC1_N1C0'  	, 'kon_AC_CaM_g_b2_b1', 'koff_AC_CaM', model);
	eid = Reac21('N1C1' ,'ACsub3', 'AC1_N1C1'  	, 'kon_AC_CaM_g_b2'   , 'koff_AC_CaM', model);
	eid = Reac21('N1C2' ,'ACsub3', 'AC1_N1C2'  	, 'kon_AC_CaM_g'      , 'koff_AC_CaM', model);
	
	eid = Reac21('N2C0' ,'ACsub3', 'AC1_N2C0'  	, 'kon_AC_CaM_b2_b1'  , 'koff_AC_CaM', model);
	eid = Reac21('N2C1' ,'ACsub3', 'AC1_N2C1'  	, 'kon_AC_CaM_b2'     , 'koff_AC_CaM', model);
	eid = Reac21('N2C2' ,'ACsub3', 'AC1_N2C2'  	, 'kon_AC_CaM'        , 'koff_AC_CaM', model);

	eid = Reac21('AC1_N0C0' ,'Ca', 'AC1_N1C0'  	, '_2kon_T_N'	, 'koff_T_N'		, model);
	eid = Reac21('AC1_N1C0' ,'Ca', 'AC1_N2C0'  	, 'kon_R_N'		, '_2koff_R_N_g'	, model);
	eid = Reac21('AC1_N0C0' ,'Ca', 'AC1_N0C1'  	, '_2kon_T_C'	, 'koff_T_C_b1'		, model);
	eid = Reac21('AC1_N0C1' ,'Ca', 'AC1_N0C2'  	, 'kon_R_C'		, '_2koff_R_C_b2'	, model);
	eid = Reac21('AC1_N1C0' ,'Ca', 'AC1_N1C1'  	, '_2kon_T_C'	, 'koff_T_C_b1'		, model);
	eid = Reac21('AC1_N0C1' ,'Ca', 'AC1_N1C1'  	, '_2kon_T_N'	, 'koff_T_N'		, model);

	eid = Reac21('AC1_N1C1' ,'Ca', 'AC1_N2C1'  	, 'kon_R_N'		, '_2koff_R_N_g'	, model);
	eid = Reac21('AC1_N1C1' ,'Ca', 'AC1_N1C2'  	, 'kon_R_C'		, '_2koff_R_C_b2'	, model);
	eid = Reac21('AC1_N0C2' ,'Ca', 'AC1_N1C2'  	, '_2kon_T_N'	, 'koff_T_N'		, model);
	eid = Reac21('AC1_N2C0' ,'Ca', 'AC1_N2C1'  	, '_2kon_T_C'	, 'koff_T_C_b1'		, model);
	eid = Reac21('AC1_N1C2' ,'Ca', 'AC1_N2C2'  	, 'kon_R_N'		, '_2koff_R_N_g'	, model);
	eid = Reac21('AC1_N2C1' ,'Ca', 'AC1_N2C2'  	, 'kon_R_C'		, '_2koff_R_C_b2'	, model);


	%%
	%% AC-CaM binding state 1 (AC1) <=> AC-CaM binding state 2 (AC2)
	%%
	eid = Reac11('AC1_N0C0' , 'AC2_N0C0'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC1_N0C1' , 'AC2_N0C1'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC1_N0C2' , 'AC2_N0C2'  	, 'kup_AC', 'kdown_AC', model);
	
	eid = Reac11('AC1_N1C0' , 'AC2_N1C0'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC1_N1C1' , 'AC2_N1C1'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC1_N1C2' , 'AC2_N1C2'  	, 'kup_AC', 'kdown_AC', model);
	
	eid = Reac11('AC1_N2C0' , 'AC2_N2C0'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC1_N2C1' , 'AC2_N2C1'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC1_N2C2' , 'AC2_N2C2'  	, 'kup_AC', 'kdown_AC', model);

	eid = Reac21('AC2_N0C0' ,'Ca', 'AC2_N1C0'  	, '_2kon_T_N'	, 'koff_T_N'		, model);
	eid = Reac21('AC2_N1C0' ,'Ca', 'AC2_N2C0'  	, 'kon_R_N'		, '_2koff_R_N_g'	, model);
	eid = Reac21('AC2_N0C0' ,'Ca', 'AC2_N0C1'  	, '_2kon_T_C'	, 'koff_T_C_b1'		, model);
	eid = Reac21('AC2_N0C1' ,'Ca', 'AC2_N0C2'  	, 'kon_R_C'		, '_2koff_R_C_b2'	, model);
	eid = Reac21('AC2_N1C0' ,'Ca', 'AC2_N1C1'  	, '_2kon_T_C'	, 'koff_T_C_b1'		, model);
	eid = Reac21('AC2_N0C1' ,'Ca', 'AC2_N1C1'  	, '_2kon_T_N'	, 'koff_T_N'		, model);

	eid = Reac21('AC2_N1C1' ,'Ca', 'AC2_N2C1'  	, 'kon_R_N'		, '_2koff_R_N_g'	, model);
	eid = Reac21('AC2_N1C1' ,'Ca', 'AC2_N1C2'  	, 'kon_R_C'		, '_2koff_R_C_b2'	, model);
	eid = Reac21('AC2_N0C2' ,'Ca', 'AC2_N1C2'  	, '_2kon_T_N'	, 'koff_T_N'		, model);
	eid = Reac21('AC2_N2C0' ,'Ca', 'AC2_N2C1'  	, '_2kon_T_C'	, 'koff_T_C_b1'		, model);
	eid = Reac21('AC2_N1C2' ,'Ca', 'AC2_N2C2'  	, 'kon_R_N'		, '_2koff_R_N_g'	, model);
	eid = Reac21('AC2_N2C1' ,'Ca', 'AC2_N2C2'  	, 'kon_R_C'		, '_2koff_R_C_b2'	, model);


	%%
	%% AC-CaM binding state 2 (AC2) <=> AC-CaM binding state 3 (AC3)
	%%
	eid = Reac11('AC2_N0C0' , 'AC3_N0C0'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC2_N0C1' , 'AC3_N0C1'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC2_N0C2' , 'AC3_N0C2'  	, 'kup_AC', 'kdown_AC', model);

	eid = Reac11('AC2_N1C0' , 'AC3_N1C0'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC2_N1C1' , 'AC3_N1C1'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC2_N1C2' , 'AC3_N1C2'  	, 'kup_AC', 'kdown_AC', model);

	eid = Reac11('AC2_N2C0' , 'AC3_N2C0'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC2_N2C1' , 'AC3_N2C1'  	, 'kup_AC', 'kdown_AC', model);
	eid = Reac11('AC2_N2C2' , 'AC3_N2C2'  	, 'kup_AC', 'kdown_AC', model);

	eid = Reac21('AC3_N0C0' ,'Ca', 'AC3_N1C0'  	, '_2kon_T_N'	, 'koff_T_N'		, model);
	eid = Reac21('AC3_N1C0' ,'Ca', 'AC3_N2C0'  	, 'kon_R_N'		, '_2koff_R_N_g'	, model);
	eid = Reac21('AC3_N0C0' ,'Ca', 'AC3_N0C1'  	, '_2kon_T_C'	, 'koff_T_C_b1'		, model);
	eid = Reac21('AC3_N0C1' ,'Ca', 'AC3_N0C2'  	, 'kon_R_C'		, '_2koff_R_C_b2'	, model);
	eid = Reac21('AC3_N1C0' ,'Ca', 'AC3_N1C1'  	, '_2kon_T_C'	, 'koff_T_C_b1'		, model);
	eid = Reac21('AC3_N0C1' ,'Ca', 'AC3_N1C1'  	, '_2kon_T_N'	, 'koff_T_N'		, model);

	eid = Reac21('AC3_N1C1' ,'Ca', 'AC3_N2C1'  	, 'kon_R_N'		, '_2koff_R_N_g'	, model);
	eid = Reac21('AC3_N1C1' ,'Ca', 'AC3_N1C2'  	, 'kon_R_C'		, '_2koff_R_C_b2'	, model);
	eid = Reac21('AC3_N0C2' ,'Ca', 'AC3_N1C2'  	, '_2kon_T_N'	, 'koff_T_N'		, model);
	eid = Reac21('AC3_N2C0' ,'Ca', 'AC3_N2C1'  	, '_2kon_T_C'	, 'koff_T_C_b1'		, model);
	eid = Reac21('AC3_N1C2' ,'Ca', 'AC3_N2C2'  	, 'kon_R_N'		, '_2koff_R_N_g'	, model);
	eid = Reac21('AC3_N2C1' ,'Ca', 'AC3_N2C2'  	, 'kon_R_C'		, '_2koff_R_C_b2'	, model);


