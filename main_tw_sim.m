%%
%% Init
%%

clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;

data_dir ='data/TimeWindow';
mkdir(data_dir);

DA_delay  = -4:0.25:4;
num_DA_delay  = numel(DA_delay);


%%
%% Model definition
%%

flag_optoDA      = 1;
flag_competitive = 0;
flag_duration    = 0.5;
[model, species, params, container] = msn_setup_TimeWindow(flag_competitive, flag_duration, flag_optoDA);
T_VGCC = container('Toffset_VGCC');
T_DA   = container('Toffset_DA');
d_DA   = container('duration_DA');

Toffset_VGCC = T_VGCC.Value;
stop_time = get(getconfigset(model), 'StopTime');


%%
%% Simulation
%%
sd   = cell(num_DA_delay, 1);
for i = 1:num_DA_delay;
	fprintf('DA timing: %d / %d \n', i, num_DA_delay );
	T_DA.Value = DA_delay(i) + Toffset_VGCC;
	sd{i,1} = sbiosimulate(model);
end;


d_DA.Value   = 0.2;
sd_noDAdip   = sbiosimulate(model);
d_DA.Value   = flag_duration;

T_VGCC.Value = stop_time + 1;
sd_noCa      = sbiosimulate(model);


%%
%% Save max concs & time courses
%%
targs = {	'Ct',	'cAMP' };
% YMAX2   = {	1.5,	4 };
max_or_min = 'max';

for k = 1:numel(targs);

	%%
	%% Save max concs
	%%
	maxconcs = maxmin_concs(targs{k}, sd, Toffset_VGCC, stop_time, max_or_min);
	save(sprintf('%s/max_%s.mat', data_dir, targs{k}), 'maxconcs');

	maxconc_noDAdip = maxmin_concs(targs{k}, sd_noDAdip, Toffset_VGCC, stop_time, max_or_min);
	save(sprintf('%s/max_%s_noDAdip.mat', data_dir, targs{k}), 'maxconc_noDAdip');

	maxconc_noCa = maxmin_concs(targs{k}, sd_noCa, Toffset_VGCC, stop_time, max_or_min);
	save(sprintf('%s/max_%s_noCa.mat', data_dir, targs{k}), 'maxconc_noCa');

	%%
	%% Save time courses
	%%
	tid = find( strcmp( sd{1,1}.DataNames, targs{k} ) );
	data ={};
	for i = 1: numel(DA_delay);
		[T, dat] = obtain_profile(targs{k}, sd{i}, Toffset_VGCC);
		data{i,1} = [T,dat];
	end
	save(sprintf('%s/%s_TimeCourse.mat',data_dir, targs{k}), 'data');
	
	data_noDAdip = obtain_profile(targs{k}, sd_noDAdip, Toffset_VGCC);
	save(sprintf('%s/%s_TimeCourse_noDAdip.mat',data_dir, targs{k}), 'data_noDAdip');

	data_noCa    = obtain_profile(targs{k}, sd_noCa, Toffset_VGCC);
	save(sprintf('%s/%s_TimeCourse_noCa.mat',data_dir, targs{k}), 'data_noCa');
	
end

save(sprintf('%s/DA_delay.mat',data_dir), 'DA_delay');



