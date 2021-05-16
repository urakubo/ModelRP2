%%
%% InitSpecies_Ca_PKA
%%
function init_species = InitSpecies_Ca_PKA(InitAC);
%%
%%
	SVR  = 30   ; % r = 0.1; % Spine

	InitPDE		 = 0.04		; 
	InitCaPump   = 0.04		; 
	InitVGCCplus = 0.0667   ; 
%	InitAC1		 = 0.0668	; 
%	InitBasalAC  = 0		;
%	InitAC5		= 0.14		;
%%%
	InitPDE			= SVR * InitPDE		;
%	InitAC1			= SVR * InitAC1		;
%	InitBasalAC 	= SVR * InitBasalAC	;
%%%
	InitCaPump   = SVR * InitCaPump 	;
	InitVGCCplus = SVR * InitVGCCplus 	;
%%%
	spec   = {
%
		'ATP'				, 2000			;
		'cAMP'				, 0				;
		'AMP'				, 0				;
		'PDE'				, InitPDE		;

		'BasalAC'			, 0			;%	;

		'ActiveAC'			, 0			;
%
		'Ca_ext'			, 1			;
		'Ca'				, 0			;
		'CaPump'			, InitCaPump;
		'ACsub3'			, InitAC	;
		'ACsub_CaM'			, InitAC	;
		'N0C0'				, 100		;
		'N1C0'				, 0			;
		'N2C0'				, 0			;
		'N0C1'				, 0			;
		'N0C2'				, 0			;
		'N1C1'				, 0			;
		'N1C2'				, 0			;
		'N2C1'				, 0			;
		'N2C2'				, 0			;
		'AC_CaM'			, 0			;
		'AC1_N0C0'			, 0			;
		'AC1_N1C0'			, 0			;
		'AC1_N2C0'			, 0			;
		'AC1_N0C1'			, 0			;
		'AC1_N0C2'			, 0			;
		'AC1_N1C1'			, 0			;
		'AC1_N1C2'			, 0			;
		'AC1_N2C1'			, 0			;
		'AC1_N2C2'			, 0			;
		'AC2_N0C0'			, 0			;
		'AC2_N1C0'			, 0			;
		'AC2_N2C0'			, 0			;
		'AC2_N0C1'			, 0			;
		'AC2_N0C2'			, 0			;
		'AC2_N1C1'			, 0			;
		'AC2_N1C2'			, 0			;
		'AC2_N2C1'			, 0			;
		'AC2_N2C2'			, 0			;
		'AC3_N0C0'			, 0			;
		'AC3_N1C0'			, 0			;
		'AC3_N2C0'			, 0			;
		'AC3_N0C1'			, 0			;
		'AC3_N0C2'			, 0			;
		'AC3_N1C1'			, 0			;
		'AC3_N1C2'			, 0			;
		'AC3_N2C1'			, 0			;
		'AC3_N2C2'			, 0			;
		'CB'				, 120		;
		'Ca_CB'				, 0			;
		'R2C2'				, 4			;
		'R2C2cAMP'			, 0			;
		'R2C2cAMP2'			, 0			;
		'R2C2cAMP3'			, 0			;
		'R2C2cAMP4'			, 0			;
		'R2C1cAMP4'			, 0			;
		'R2C0cAMP4'			, 1			;
		'Ct'				, 0			;
		'VGCC'				, 0			;
		'VGCCplus'			, InitVGCCplus	;
		'VGCC_dummy'		, 0			;
		'SVR'				, SVR
		};

	init_species = cell2table( spec, 'VariableNames', {'Name','Conc'});
	init_species.Properties.RowNames = spec(:,1);



