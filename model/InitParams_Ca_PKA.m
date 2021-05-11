%%
%%
%%
function init_params_Ca_PKA = InitParams_Ca_PKA();
%%
	SVR = SVRtarg/SVRspine;
%%
	% alpha	= 100;
	beta1	= 1.600000e-03;
	beta2	= 1.040000e-01;
	gamma	= 2.870000e-02;

	koff_R_N = 22000		;
	koff_T_C = 2600			;
	koff_R_C = 6.500000e+00	;

	spec   = {
%%
%% AC1 cAMP production PDE degradation
%%
		'Km_PDE'			, 0.05			;% 
		'kcat_PDE'			, 0.3			;%
%%
%% cAMP - PKA reaction
%%
		'kon_A'				, 2 			; %
		'koff_A'			, 10			; %
%
		'kon_C'				, 10			;
		'koff_C'			, 40			;
%
		'BasalAC'			, 0.01			;
%%
%% DARPP32 phosphorylation & PP1 binding
%%
		'kcat_T34P'			, 5.0	;
		'Km_T34P'			, 2.4	;
		'kcat_T34DP'		, 0.5	;
		'Km_T34DP'			, 1.6	;
%
		'kon_D32p_PP1'		, 2;	;
		'koff_D32p_PP1'		, 0.01	;
		'koff_D32_PP1'		, 0.5	;
%%
%% Ca
%%
		'CtSd'				, 1				;
%
		'kpump_Ca'			, 1600		; %%%%%% ?????
		'kon_CB'			, 75		;
		'koff_CB'			, 29.5		;
		'kdeact_VGCC'		, 33.35		;
		'kinflux_Ca'		, 2500		;
%%
%% cAMP generation
%%
		'kcat_decomp'		, 0.33			;
		'Km_decomp'			, 0.05			;
		'kcat_synth'		, 100			;
		'Km_synth'			, 1				;
%%
%% AC-CaM binding
%%

		'Km_AC'				, 0.1		;% 
		'kcat_AC'			, 100		;% 
%
		'kon_AC_CaM'		, 50	; %% temp = *5
		'koff_AC_CaM'		, 20	; %% temp = *5
%
		'kup_AC'			, 4.0		;
		'kdown_AC'			, 4.0		;
%
		'kon_AC_CaM_g'		, 1.435000e-01		;
		'kon_AC_CaM_g_b2'	, 1.492400e-02		;
		'kon_AC_CaM_g_b2_b1', 2.387840e-05		;
		'kon_AC_CaM_b2_b1'	, 8.320000e-04		;
		'kon_AC_CaM_b2'		, 5.200000e-01		;
%
		'kon_T_C'			, 84			;
		'kon_T_N'			, 770			;
		'koff_T_N'			, 160000		;
		'kon_R_C'			, 25			;
		'kon_R_N'			, 32000			;
%
		'koff_R_N'			, koff_R_N			;
		'koff_T_C'			, koff_T_C			;
		'koff_R_C'			, koff_R_C			;
		'koff_R_N_g'		, koff_R_N * gamma	;
		'koff_T_C_b1'		, koff_T_C * beta1	;
		'koff_R_C_b2'		, koff_R_C * beta2	;
		};

%%
%%
	spec_res  = {
	%
		'kon_T_C'	;
		'koff_T_C'	;
		'kon_T_N'	;
		'koff_T_N'	;
		'kon_R_C'	;
		'koff_R_C'	;
		'kon_R_N'	;
		'koff_R_N'	;
		'koff_R_N_g' 	;
		'koff_T_C_b1' 	;
		'koff_R_C_b2' 	;
	%
		'kon_C'		;
		'koff_C'	;
		'kon_A'		;
		'koff_A'
	};
%%
%%
	spec2 = cell(numel(spec_res),2);
	for i = 1:numel(spec_res);
		spec2{i,1} = sprintf('_2%s', spec_res{i});
		id = find(strcmp(spec_res{i}, spec(:,1)));
		spec2{i,2} = 2 * spec{id,2};
	end;
%%
%%
	spec_res  = {
		'kon_A'		;
		'koff_A'
	};

	spec4 = cell(numel(spec_res),2);
	for i = 1:numel(spec_res);
		spec4{i,1} = sprintf('_4%s', spec_res{i});
		id = find(strcmp(spec_res{i}, spec(:,1)));
		spec4{i,2} = 4 * spec{id,2};
	end;

	spec10 = cell(numel(spec_res),2);
	for i = 1:numel(spec_res);
		spec10{i,1} = sprintf('_10%s', spec_res{i});
		id = find(strcmp(spec_res{i}, spec(:,1)));
		spec10{i,2} = 10 * spec{id,2};
	end;

	spec16 = cell(numel(spec_res),2);
	for i = 1:numel(spec_res);
		spec16{i,1} = sprintf('_16%s', spec_res{i});
		id = find(strcmp(spec_res{i}, spec(:,1)));
		spec16{i,2} = 16 * spec{id,2};
	end;

	init_params = [spec;spec2;spec4;spec10;spec16];
%%
%%
