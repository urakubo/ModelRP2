%%
%% Init
%%

clear;
addpath('./model');
addpath('./funcs');
addpath('./funcs2');

flag_competitive 		= 1;
flag_Gi_sequestrated_AC = 1;
flag_optoDA 			= 0;
flag_duration 			= -1;

data_dir = 'data';
TITLE = sprintf('2D_Compet_%g_tau_Golf', flag_competitive);

%%
%% Model definition
%%
[model, species, params, container] = ...
	msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration);
Toffset = container('Toffset_DA').Value;



%%
%% sim 2D
%%
targ  = {'tau_Golf','RGS'};
mconc{1} = 10.^[-2:0.05:2];
mconc{2} = 10.^[-1:0.025:1];
conc{1} = mconc{1};
conc{2} = mconc{2} * species{targ{2},'Obj'}.InitialAmount;

% Simulation
[AC_basal_sim, AC_dip_sim, AC_t_sim] = sim_2D(conc, targ, species, model, Toffset);

AC_basal_th = [];
AC_dip_th = [];
AC_t_th = [];

FILENAME =  sprintf('%s/%s_%s_%s.mat', data_dir, TITLE, targ{1}, targ{2});

parsave_sim_2D(FILENAME, model, params, species, ...
	mconc, conc, targ, ...
	AC_basal_sim, AC_dip_sim, AC_t_sim, ...
	AC_basal_th, AC_dip_th, AC_t_th);


