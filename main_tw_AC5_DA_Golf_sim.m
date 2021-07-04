%%
%% Init
%%

clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;


id_state = 1;


save_targs = {'DA','Golf','ActiveAC'};
DA_delay  = -3:0.25:4;
num_DA_delay  = numel(DA_delay);


dec_inc = {'decDA_incGolf', 'decDA_decGolf', 'incDA_decGolf', 'incDA_incGolf'};


targ_dirs    = {'data/tw_healthy_adult_' , ...
				'data/tw_healthy_infant_', ...
				'data/tw_schizophrenia_' , ...
				'data/tw_dystonia_'};
data_dir     = targ_dirs{id_state};
mult_targs   = {'D2R','RGS'};
mults        = {[1,1], [0.5,0.5], [4.0, 0.5], [0.5, 2.0]};


%%
%% Model definition
%%

flag_optoDA      = 0;
flag_competitive = 0;
flag_duration    = 1.6;;

[model, species, params, container] = msn_setup_TimeWindow_AC5_DA_Golf(flag_competitive, flag_duration, flag_optoDA);
DA_dip   = container('DA_dip');
DA_basal = container('DA_basal');
Golf_basal = container('Golf_basal');
Golf_burst = container('Golf_burst');

for i = 1: numel(mult_targs)
	species{mult_targs{i},'Obj'}.InitialAmount = species{mult_targs{i},'Obj'}.InitialAmount * mults{id_state}(i);
end


%%
%% Simulation under various inputs
%%
for id_dec_inc = 1:numel(dec_inc)

	% Makedir
	data_dir = append(targ_dirs{id_state}, dec_inc{id_dec_inc});
	mkdir(data_dir);
	disp(data_dir);

	% Define input
	switch  dec_inc{id_dec_inc}
		case 'decDA_incGolf'
			DA_basal.Value = 0.5;
			DA_dip.Value   = 0.05;
			Golf_basal.Value = 0.8*0.2;
			Golf_burst.Value = 0.8;
		case 'decDA_decGolf'
			DA_basal.Value = 0.5;
			DA_dip.Value   = 0.05;
			Golf_basal.Value = 0.8;
			Golf_burst.Value = 0.8*0.2;
		case 'incDA_decGolf'
			DA_basal.Value = 0.5;
			DA_dip.Value   = 2.0;
			Golf_basal.Value = 0.8;
			Golf_burst.Value = 0.8*0.2;
		case 'incDA_incGolf'
			DA_basal.Value = 0.5;
			DA_dip.Value   = 2.0;
			Golf_basal.Value = 0.8*0.2;
			Golf_burst.Value = 0.8;
		otherwise
			fprintf('%s ', dec_inc{id_dec_inc});
			warning('unexpected.');
	end

	% Simulation & save
	[sd, sd_noDAdip, sd_constGolf] = sim_tw_DA_Golf(model, DA_delay, container);
	save_tw_max_concs_DA_Golf(sd, sd_noDAdip, sd_constGolf, save_targs, data_dir, container, DA_delay);
	save_tw_time_courses_DA_Golf(sd, sd_noDAdip, sd_constGolf, save_targs, data_dir, container, DA_delay);
end





%%
%% Functions
%%
function save_tw_max_concs_DA_Golf(sd, sd_noDAdip, sd_constGolf, targs, data_dir, container, DA_delay);

	T_Golf   = container('Toffset_Golf');
	Toffset_Golf = T_Golf.Value + min(DA_delay);

	for k = 1:numel(targs);
		maxconcs = max_concs(targs{k}, sd, Toffset_Golf);
		save(sprintf('%s/maxconcs_%s.mat', data_dir, targs{k}), 'maxconcs');

		maxconc_noDAdip = max_concs(targs{k}, sd_noDAdip, Toffset_Golf);
		save(sprintf('%s/maxconc_noDAdip_%s.mat', data_dir, targs{k}), 'maxconc_noDAdip');

		maxconc_constGolf = max_concs(targs{k}, sd_constGolf, Toffset_Golf);
		save(sprintf('%s/maxconc_constGolf_%s.mat', data_dir, targs{k}), 'maxconc_constGolf');
	end
	
	save(sprintf('%s/DA_delay.mat',data_dir), 'DA_delay');
	
end


%%
%%
%%
function save_tw_time_courses_DA_Golf(sd, sd_noDAdip, sd_constGolf, targs, data_dir, container, DA_delay);

	T_Golf   = container('Toffset_Golf');
	Toffset_Golf = T_Golf.Value;

	for k = 1:numel(targs);
		time_courses ={};
		for i = 1: numel(sd);
			[T, DATA] = obtain_profile(targs{k}, sd{i}, Toffset_Golf);
			time_courses{i} = [T, DATA];
		end
		save(sprintf('%s/time_courses_%s.mat',data_dir, targs{k}), 'time_courses');
		
		time_courses_noDAdip = obtain_profile(targs{k}, sd_noDAdip, Toffset_Golf);
		save(sprintf('%s/time_courses_noDAdip_%s.mat',data_dir, targs{k}), 'time_courses_noDAdip');

		time_courses_constGolf = obtain_profile(targs{k}, sd_constGolf, Toffset_Golf);
		save(sprintf('%s/time_courses_constGolf_%s.mat',data_dir, targs{k}), 'time_courses_constGolf');
	end
end


