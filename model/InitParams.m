%%
%%
%%
function init_params = InitParams();


		a = 2; % 0.5, 0.2

	spec  = {
		'Zero'				, 0			;

		'kf_DA_D2R'			, 10	; %% 100倍 (19/5/23)
		'kb_DA_D2R'			, 100	; %% 100倍 (19/5/23)

		'Km_exch_Gi'		, 0.01		; %%%
		'kcat_exch_Gi'		, 250; % 	  	; %%% *1.8;
%
		'Km_hyd_Gi'			, 12  ; %%%
		'kcat_hyd_Gi'		, 65; ; %%% *1.4
%
		'kon_AC_GiGTP'		, a*100	; %%% 
		'koff_AC_GiGTP'		, a*4	; %%%			
%
		'kon_AC_GiGDP'		, a*100/10	; %%% 
		'koff_AC_GiGDP'		, a*108/10	; %%% 
%
		'kon_Gbc_Gi'		, 10	; %%% 

		};
%%
%%
	init_params = cell2table( spec, 'VariableNames', {'Name','Param'});
	init_params.Properties.RowNames = spec(:,1);
%%


