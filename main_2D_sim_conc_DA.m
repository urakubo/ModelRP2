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


%%
%% Model definition
%%
[model, species, params, container] = ...
	msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration);
Toffset  = container('Toffset_DA').Value;


%%
%% sim 2D
%%
targ     = {'RGS' ,'D2R'};
targ_for_theory = {'D2R', 'AC1' ,'RGS' ,'Gi_Gbc' ,'Golf'};


mconc = {};
conc  = {};
for j = 1:numel(targ);
	mconc{j}	 = 10.^[-1:0.025:1]; %	tmp = 10.^[-1:0.1:1];
	default_conc = species{targ{j},'Obj'}.InitialAmount;
	conc{j}		 = mconc{j} .* default_conc;
	fprintf('Standard conc %s: %g uM \n', targ{j}, default_conc );
end

%%
DAbasals1 = 2.^[-2:2] * 0.5;
DAdips1   = ones(size(DAbasals1)) * 0.05;
DAdips2   = 2.^[-2:2] * 0.05;
DAbasals2 = ones(size(DAdips2)) * 0.5;
DAbasals = [DAbasals1, DAbasals2];
DAdips   = [DAdips1, DAdips2];
%%

%% Please use below if you do not have "Parallel Computing Toolbox."
%% for  i = 1:numel(DAbasals); 

parfor i = 1:numel(DAbasals);

	% Set
	fprintf('DAbasal: %g, DAdip: %g \n', DAbasals(i), DAdips(i));

	% Theory
	targ_concs = init_concs_2D(species, targ, conc, targ_for_theory); %
	[ AC_basal_th, AC_dip_th, AC_t_th ] = ...
		theory(flag_competitive,  targ_concs{1}, targ_concs{2}, targ_concs{3}, targ_concs{4}, targ_concs{5}, ...
		params, DAbasals(i), DAdips(i));

	% Simulation
	[AC_basal_sim, AC_dip_sim, AC_t_sim] = sim_2D(conc, targ, species, model, Toffset, DAbasals(i), DAdips(i));

	% Save
	Targ_dir = sprintf('%s/2D_DAbasal_%g_DAdip_%g', data_dir, DAbasals(i), DAdips(i));
	FILENAME =  sprintf('%s/compet_%g_%s_%s.mat', Targ_dir, flag_competitive, targ{1}, targ{2});
	mkdir(Targ_dir);
	disp(Targ_dir);

	parsave_sim_2D(FILENAME, model, params, species, ...
		mconc, conc, targ, ...
		AC_basal_sim, AC_dip_sim, AC_t_sim, ...
		AC_basal_th, AC_dip_th, AC_t_th);

end

