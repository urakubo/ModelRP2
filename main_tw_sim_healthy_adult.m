%%
%% Init
%%

clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;


save_targs = {'Ct','cAMP'};
DA_delay  = -4:0.25:4;
num_DA_delay  = numel(DA_delay);


data_dir = 'data/tw_healthy_adult';
mkdir(data_dir);


%%
%% Model definition
%%

flag_optoDA      = 0; % 1;
flag_competitive = 0;
flag_duration    = 0.5;
[model, species, params, container] = msn_setup_TimeWindow(flag_competitive, flag_duration, flag_optoDA);


%%
%% Simulation & save
%%

[sd, sd_noDAdip, sd_noCa] = sim_tw(model, DA_delay, container);
save_tw_max_concs(sd, sd_noDAdip, sd_noCa, save_targs, data_dir, container);
save_tw_time_courses(sd, sd_noDAdip, sd_noCa, save_targs, data_dir, container);
save(sprintf('%s/DA_delay.mat',data_dir), 'DA_delay');


