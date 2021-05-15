%%
%%
%%

%%
function init_species = InitSpecies();
%%

%%
	m = 3/5; % 3/5
	InitGi		 = m * 15 	;
	InitD2R		 = m * InitGi ./30	; 
	InitGbc		 = m * 10; 
	InitAC		 = m * InitGi ./30 /2  ;
	InitRGS		 = m * (InitGbc+InitGi) / 2 /5;

	InitGolf	 = 0.08;

%	InitGolf	 = 0.09;
%	InitGolf	 = 0.5;
%	InitGolf	 = 0.10;
%%
%	InitGolf	 = 0.5;
%	InitRGS		 = InitRGS ./ 3;
%%
	fprintf('AC conc: %g uM \n', InitAC	);
	fprintf('Gi conc  : %g uM \n', InitGi	);
	fprintf('InitD2R conc: %g uM \n', InitD2R	);
	fprintf('InitAC  conc: %g uM \n', InitAC	);
	fprintf('InitRGS conc: %g uM \n', InitRGS	);


	spec   = {
%		'AllGi'			, 0				;
%
		'None'			, 0				;
		'DAT'			, 1				;
%
		'AC1'			, InitAC		;
		'AC1tot'		, 0				;
%
		'DA'			, 0				;
		'D2R'			, InitD2R		;
		'DA_D2R'		, 0				;
		'Gbc'			, InitGbc		; 
		'Gi_GDP'		, 0;
		'Gi_GTP'		, 0				;
		'Gi_Gbc'		, InitGi		;
		'AC1_Gi_GDP'	, 0				;
		'AC1_Gi_GTP'	, 0				;
%
		'Golf'			, InitGolf 		;
		'Golf_AC1'		, 0				;
%		'ActiveAC'		, 0				;
		'RGS'			, InitRGS		;
%
		'AC2'			, 1				;
		'Golf_AC2'		, 0				;
%
		'Golf_bound'	, 0				;
		'Gitot'			, InitGi		;
		'ACtot'			, InitAC		;
		'ACact'			, 0				;
%
		};
%
	init_species = cell2table( spec, 'VariableNames', {'Name','Conc'});
	init_species.Properties.RowNames = spec(:,1);


