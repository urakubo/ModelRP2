%%
%%
%%
function init_params = InitParams();


		a = 2; % 0.5, 0.2

	spec  = {
		'Zero'				, 0			;

		'kf_DA_D2R'			, 10	; %%
		'kb_DA_D2R'			, 100	; %%

		'Km_exch_Gi'		, 0.01		; %%%
		'kcat_exch_Gi'		, 250; %
%
		'Km_hyd_Gi'			, 12  ; %%%
		'kcat_hyd_Gi'		, 65; ; %%%
%
		'kon_AC_GiGTP'		, a*100	; %%% 
		'koff_AC_GiGTP'		, a*4	; %%%			
%
		'kon_AC_GiGDP'		, a*10.0	; %%% 
		'koff_AC_GiGDP'		, a*10.8	; %%% 
%
		'kon_Gbc_Gi'		, 10	; %%% 

		};
%%
%%
	init_params = cell2table( spec, 'VariableNames', {'Name','Param'});
	init_params.Properties.RowNames = spec(:,1);
%%


