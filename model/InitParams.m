%%
%%
%%
function init_params = InitParams();


	a = 1; %

	spec  = {
		'Zero'				, 0			;
%
		'Km_DAT'			, 0.2;
		'kcat_DAT'			, 8.9;% 4.6   ; % 
		'DA_opto'			, 0.841;% 0.6365; % 
%
		'kf_DA_D2R'			, 10	; %% 100倍 (19/5/23)
		'kb_DA_D2R'			, 100	; %% 100倍 (19/5/23)

		'Km_exch_Gi'		, 0.01		; %%%
		'kcat_exch_Gi'		, 230; % 260	; % 
%
		'Km_hyd_Gi'			, 12  	; %%%
		'kcat_hyd_Gi'		, 90; %80 ; %% 	; %%% *1.4
%
		'kon_AC_GiGTP'		, a*200	; %%% 
		'koff_AC_GiGTP'		, a*8	; %%%			
%
		'kon_AC_GiGDP'		, a*20	 ; %%% 
		'koff_AC_GiGDP'		, a*21.6 ; %%% 
%
		'kon_AC_Golf'		, 20; % 40	; %%% 5*40
		'koff_AC_Golf'		, 20; % 40 	; %%% 5*4
%
		'kon_Gbc_Gi'		, 10	; %%% 

		};
%%
%%
	init_params = cell2table( spec, 'VariableNames', {'Name','Param'});
	init_params.Properties.RowNames = spec(:,1);
%%


