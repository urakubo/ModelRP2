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
DA_delay  = -3:0.25:4;
num_DA_delay  = numel(DA_delay);


%%
%% Model definition
%%

flag_optoDA      = 1; % 0;
flag_competitive = 0;
flag_duration    = 0.5;
[model, species, params, container] = msn_setup_TimeWindow(flag_competitive, flag_duration, flag_optoDA);


%%
%% Concs of D2R and RGS
%%

mult_targs       = {'D2R','RGS'};
mults            = {[1,1], [0.5,0.5], [4.0, 0.5], [0.5, 2.0]};
dirs_mult_targ   = {'data/tw_healthy_adult', 'data/tw_healthy_infant', 'data/tw_schizophrenia', 'data/tw_dystonia'};
reserv_targs     = {};
for i = 1: numel(mult_targs)
	reserv_targs{i} = species{mult_targs{i},'Obj'}.InitialAmount;
end
for j = 1: numel(dirs_mult_targ)
	mkdir(dirs_mult_targ{j});
end



%%
%% Simulation & save
%%

for j = 1: numel(mults)

	disp(dirs_mult_targ{j});

	for i = 1: numel(mult_targs)
		species{mult_targs{i},'Obj'}.InitialAmount = reserv_targs{i} * mults{j}(i);
	end

	[sd, sd_noDAdip, sd_noCa] = sim_tw(model, DA_delay, container);
	save_tw_max_concs(sd, sd_noDAdip, sd_noCa, save_targs, dirs_mult_targ{j}, container);
	save_tw_time_courses(sd, sd_noDAdip, sd_noCa, save_targs, dirs_mult_targ{j}, container);
	save(sprintf('%s/DA_delay.mat', dirs_mult_targ{j}), 'DA_delay');

end


