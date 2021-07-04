%%
%% Init
%%

clear;
addpath('./model');
addpath('./funcs');
addpath('./funcs2');


flag_competitive 		=  0; % 0: non-competitive ; 1: competitive
flag_Gi_sequestrated_AC =  1; % 0: non-sequestrated; 1: sequestrated
flag_optoDA 			=  0; % 0: Constant        ; 1: Opto
flag_duration 			= -1; % -1: Persistent drop; 0: No pause; >0: pause duration;


data_dir = 'data';
TITLE = sprintf('2D_Compet_%g_Sequest_%g', flag_competitive, flag_Gi_sequestrated_AC);


%%
%% Model definition
%%

targs = {'D2R', 'AC1' ,'RGS' ,'Gi_Gbc' ,'Golf'};
dims  = { [3,1], [2,1], [2,3], [3,5] };

[model, species, params, container] = ...
	msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration);
Toffset = container('Toffset_DA').Value;

for j = 1:numel(targs);
	mult_concs{j}	= 10.^[-1:0.025:1]; %	tmp = 10.^[-1:0.1:1];
	default_conc	= species{targs{j},'Obj'}.InitialAmount;
	concs{j}		= mult_concs{j} .* default_conc;
	fprintf('Standard conc %s: %g uM \n', targs{j}, default_conc );
end


%%
%% sim 2D
%%

%% Please use below if you do not have "Parallel Computing Toolbox."
%% for  i = 1:numel(dims); 

parfor  i = 1:numel(dims);

	mconc = mult_concs(dims{i});
	conc = concs(dims{i});
	targ = targs(dims{i});

	% Simulation
	[AC_basal_sim, AC_dip_sim, AC_t_sim] = sim_2D(conc, targ, species, model, Toffset);

	% Theory
	targ_concs = init_concs_2D(species, targ, conc, targs);
	[ AC_basal_th, AC_dip_th, AC_t_th ] = theory(flag_competitive, targ_concs{1}, targ_concs{2}, targ_concs{3}, targ_concs{4}, targ_concs{5}, params);

	FILENAME =  sprintf('%s/%s_%g_%g.mat', data_dir, TITLE, dims{i}(1), dims{i}(2));
	parsave_sim_2D(FILENAME, model, params, species, ...
		mconc, conc, targ, ...
		AC_basal_sim, AC_dip_sim, AC_t_sim, ...
		AC_basal_th, AC_dip_th, AC_t_th);

end

