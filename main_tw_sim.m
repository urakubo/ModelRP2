%%
%% Init
%%

clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;


targ_dirs    = {'data/tw_healthy_adult', 'data/tw_healthy_infant', 'data/tw_schizophrenia', 'data/tw_dystonia'};
mult_targs   = {'D2R','RGS'};
mults        = {[1,1], [0.5,0.5], [4.0, 0.5], [0.5, 2.0]};


save_targs = {'Ca','DA','Golf','ActiveAC'};
DA_delay  = -3:0.25:4;
num_DA_delay  = numel(DA_delay);

%%
%% Model definition
%%


flag_competitive 		=  0; % 0: non-competitive ; 1: competitive
flag_Gi_sequestrated_AC =  1; % 0: non-sequestrated; 1: sequestrated
flag_optoDA 			=  1; % 0: Constant        ; 1: Opto
flag_duration 			=  0.5; % -1: Persistent drop; 0: No pause; >0: pause duration;

[model, species, params, container] = msn_setup_TimeWindow(flag_competitive, flag_duration, flag_optoDA);

%%
%% Simulation & save
%%


for i = 1: numel(mult_targs)
	reserv{i} = species{mult_targs{i},'Obj'}.InitialAmount;
end

for id_state = 1:numel(targ_dirs)

	data_dir = targ_dirs{id_state};
	mkdir(data_dir);
	disp(targ_dirs{id_state})

	for i = 1: numel(mult_targs)
		species{mult_targs{i},'Obj'}.InitialAmount = reserv{i} * mults{id_state}(i);
	end

	[sd, sd_noDAdip, sd_noCa] = sim_tw(model, DA_delay, container);
	save_tw_max_concs(sd, sd_noDAdip, sd_noCa, save_targs, data_dir, container);
	save_tw_time_courses(sd, sd_noDAdip, sd_noCa, save_targs, data_dir, container);
	save(sprintf('%s/DA_delay.mat',data_dir), 'DA_delay');

end

