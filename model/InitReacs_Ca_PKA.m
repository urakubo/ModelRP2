%%
%%
%%

function InitReacs_Ca_PKA(model, species, params); %


	%% cAMP production -> degradation
	eid = ReacEnz('ATP', 'ActiveAC', 'cAMP'					, 'Km_AC', 'kcat_AC', model);
	eid = ReacEnz('cAMP', 'PDE', 'AMP'						, 'Km_PDE', 'kcat_PDE', model);

	%%
	%% AC5
	%%
	eid = Reac21('Golf_GTP', 'AC5sub1', 'AC5sub1_Golf_GTP'	, 'kon_AC5_GolfGTP' , 'koff_AC5_GolfGTP', model);
	eid = Reac12('AC5sub1_Golf_GDP', 'AC5sub1', 'Golf_GDP'	, 'koff_AC5_GolfGDP', 'kon_AC5_GolfGDP', model);
	eid = ReacOneWay('AC5sub1_Golf_GTP', 'AC5sub1_Golf_GDP'	, 'kcat_hyd_Golf', model);

	%%
	%% PKA_cAMP associ
	%%
	eid = Reac21('R2C2', 		'cAMP', 'R2C2cAMP'  		, 'kon_A'	 , '_16koff_A', model);
	eid = Reac21('R2C2cAMP', 	'cAMP', 'R2C2cAMP2' 		, 'kon_A'	 , '_4koff_A', model);
	eid = Reac21('R2C2cAMP2',   'cAMP', 'R2C2cAMP3'  		, '_4kon_A' , 'koff_A', model);
	eid = Reac21('R2C2cAMP3', 	'cAMP', 'R2C2cAMP4' 		, '_16kon_A' , 'koff_A', model);

	eid = Reac12('R2C2cAMP4',   'Ct', 'R2C1cAMP4'  			, '_2koff_C'	, 'kon_C', model);
	eid = Reac12('R2C1cAMP4', 	'Ct', 'R2C0cAMP4' 			, 'koff_C'	, '_2kon_C', model);

	%% DARPP32-PP1 interaction
	eid = ReacEnz('D34p', 		'PP2B',	'D' 				, 'Km_T34DP',		'kcat_T34DP', model);
	eid = ReacEnz('D' 	, 		'Ct',	'D34p' 				, 'Km_T34P' ,		'kcat_T34P' , model);
	eid = ReacEnz('D34p_PP1', 	'PP2B',	'D_PP1' 			, 'Km_T34DP',		'kcat_T34DP', model);
	eid = ReacEnz('D_PP1' ,		'Ct',	'D34p_PP1' 			, 'Km_T34P' , 		'kcat_T34P' , model);
	eid = Reac21('D34p', 		'PP1',	'D34p_PP1' 			, 'kon_D32p_PP1',	'koff_D32p_PP1', model);
	eid = Reac12('D_PP1',		'D',	'PP1'	  			, 'koff_D32_PP1',	'Zero', model);

	r = addrule(model,'D34p_tot  = D34p_PP1 + D34p', 'repeatedAssignment');


	%% Ca-CB binding
	eid = Reac21( 'CB'  ,'Ca', 'Ca_CB' 						, 'kon_CB'	, 'koff_CB', model);

	%% Ca uptake
	eid = ReacChannel('Ca', 'CaPump', 'Ca_ext'				, 'kpump_Ca'		, model);
	
	%% Ca influx 
	eid = ReacChannel('Ca_ext', 'VGCC', 'Ca'		, 'kinflux_Ca'		, model);
	eid = ReacOneWay('VGCC', 'VGCC_dummy'			, 'kdeact_VGCC'		, model);

	%% Constant species
	set(species{'ATP','Obj'}, 'ConstantAmount', true);
	set(species{'DA_basal','Obj'}, 'ConstantAmount', true);
	set(species{'Ca_ext','Obj'}, 'ConstantAmount', true);
	set(species{'VGCC_dummy','Obj'}, 'ConstantAmount', true);

	%%
	%% AC1-CaCaM interaction
	%%
	
	CaM_AC_Reacs(model, species, params)
	tmp = 'AC_CaM = AC3_N0C0 + AC3_N0C1 + AC3_N0C2 + AC3_N1C0 + AC3_N1C1 + AC3_N1C2 + AC3_N2C0 + AC3_N2C1 + AC3_N2C2';
	r = addrule(model, tmp,'repeatedAssignment');


	%%
	%% Active AC1 interaction
	%%

	%% AC1
	r = addrule(model,'Golf_bound_AC  = (ACsub1_Golf_GTP + ACsub1_Golf_GDP)', 'repeatedAssignment');
	r = addrule(model,'Gi_unbound_AC  = ACsub0-(ACsub2_Gi_GTP + ACsub2_Gi_GDP)', 'repeatedAssignment');	
	r = addrule(model,'ActAC1 = (Gi_unbound_AC/ACsub0) * (Golf_bound_AC/ACsub0) * AC_CaM', 'repeatedAssignment');


	%% AC5
	r = addrule(model,'Golf_bound_AC5  = (AC5sub1_Golf_GTP + AC5sub1_Golf_GDP)', 'repeatedAssignment');
	r = addrule(model,'ActAC5 = Golf_bound_AC5','repeatedAssignment'); % If AC5 conc is not Zero.


	%% All ACs
	r   = addrule(model,'ActiveAC = ActAC1 + ActAC5 + BasalAC','repeatedAssignment');


	%%
	r = addrule(model,'AllGi = Gi_Gbc + Gi_GTP + Gi_GDP + ACsub2_Gi_GTP + ACsub2_Gi_GDP', 'repeatedAssignment');
	r = addrule(model,'AllGolf = Golf_Gbc + Golf_GTP + Golf_GDP + ACsub1_Golf_GTP + ACsub1_Golf_GDP', 'repeatedAssignment');

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






