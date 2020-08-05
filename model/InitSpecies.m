%%
%%
%%

%%
function init_species = InitSpecies(DAbasal);
%%

%%
	m = 3/5; % 3/5
	InitGi		 = m * 15 	;
	InitD2R		 = m * InitGi ./30	; 
	InitGbc		 = m * 10; 
	InitAC		 = m * InitGi ./30 ;
	InitRGS		 = m * (InitGbc+InitGi) / 2 /5;
%%
%%
	fprintf('AC conc: %g uM \n', InitAC	);
	fprintf('Gi conc  : %g uM \n', InitGi	);
	fprintf('InitD2R conc: %g uM \n', InitD2R	);
	fprintf('InitAC  conc: %g uM \n', InitAC	);
	fprintf('InitRGS conc: %g uM \n', InitRGS	);


	spec   = {
		'AllGi'			, 0				;
%
		'AC1'			, InitAC		;
		'ActAC1'		, 0				;
%
		'DA'			, DAbasal		;
		'DA_basal'		, DAbasal		;
		'D2R'			, InitD2R		;
		'DA_D2R'		, 0				;
		'Gbc'			, InitGbc		; 
		'Gi_GDP'		, 0;
		'Gi_GTP'		, 0				;
		'Gi_Gbc'		, InitGi		;
		'Gi_unbound_AC'	, 0				;
		'AC1_Gi_GDP'	, 0				;
		'AC1_Gi_GTP'	, 0				;
		'ActiveAC'		, 0				;
		'RGS'			, InitRGS		; 
		};
	init_species = cell2table( spec, 'VariableNames', {'Name','Conc'});
	init_species.Properties.RowNames = spec(:,1);


