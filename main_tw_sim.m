%%
%% Init
%%

clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;

data_dir ='data/TimeWindow/';
img_dir ='imgs/';

Toffsets_DA  = -4:0.25:4;
numToffsets_DA  = numel(Toffsets_DA);


%%
%% Model definition
%%

flag_optoDA      = 0;
flag_competitive = 0;
flag_duration    = 0.5;
[model, species, params, T_VGCC, T_DA] = msn_setup_TimeWindow(flag_competitive, flag_duration, flag_optoDA);

Toffset    = T_VGCC.Value;
T_DA.Value = T_VGCC.Value + 0.5;


%%
%% Simulation
%%
sd   = cell(numToffsets_DA, 1);

for i = 1:numToffsets_DA;
	fprintf('DA timing: %d / %d \n', i, numToffsets_DAs );
	tDA.Value = Toffsets_DA(i) + Toffset_VGCC;
	sd{i,1} = sbiosimulate(model);
end;



	%%
	%% Plot
	%%
	Ymin 	  = 0;

	switch TYPE
   	case 'D1'
		% TNAME = {	'Ca',	'ActAC1',	'DA',	'Ca',	'cAMP', 'Ct'};
		% YMAX  = {	'1', 	0.4,		5.0,	1.6,	4, 		1.5};
      	% TNAME = {	'Ca',	'ActiveAC',	'DA_D1R',	'Golf_bound_AC', 'AC_CaM',	'cAMP', 'Ct', 'ActiveCK'};
		% YMAX  = {	'1', 	0.4,		 0.04,	 	1, 				1,			4, 		1.5, 	40};
      	TNAME = {	'Ct',	'cAMP' };
		YMAX  = {	4,	4};
      	TNAME2 = {	'Ct',	'cAMP' };
		YMAX2  = {	4,	4};
   	case 'D2'
      	% TNAME = {	'Ca',	'ActiveAC',	'DA_D2R',	'Gbc',	'Gi_unbound_AC',	'DA',	'Ca',	'cAMP', 'Ct', 'ActiveCK'};
		% YMAX  = {	'1', 0.4,		 0.04,	 	   6,	1.2,				5.0,	1.6,		4, 1.5, 	40};
	    TNAME = {	'Ct',	'cAMP' };
		YMAX  = {	1.5,	4 };

	end


	%%%
	%%% Plot timing dependence
	%%%

    TNAME2 = {	'Ct',	'cAMP' };
	YMAX2  = {	1.5,	4 };
	for k = 1:numel(TNAME2);
		concs = max_concs(TNAME2{k}, sd, numCa_Durations, numToffsets_DA, Tstart, Tend, Toffset);
		save(sprintf('%s%s_%s_%g_%g_%s_Timing.mat',data_dir, TYPE, TNAME2{k}, SVR, DAbasal, STIM), 'concs');
	end;

	%%%
	%%% Save data
	%%%
	for k = 1:numel(TNAME);
		tid = find( strcmp( sd{1,1}.DataNames, TNAME{k} ) );
		data ={};
		for j = 1: numCa_Durations;
			for i = 1: numel(Toffsets_DA);
				T = sd{i,j}.Time - Toffset;
				dat = sd{i,j}.Data(:,tid);
				data{i,j} = [T,dat];
			end
		end
		save(sprintf('%s%s_%s_%g_%g_%s_TimingTimeCourse.mat',data_dir,TNAME{k}, TYPE, SVR, DAbasal, STIM), 'data');
	end
	DA_delay = Toffsets_DA;
	save(sprintf('%sDA_delay_%s_%g_%g_%s_TimingTimeCourse.mat',data_dir, TYPE, SVR, DAbasal, STIM), 'DA_delay');
	Ca_dur   = Ca_Durations;
	save(sprintf('%sDA_dur_%s_%g_%g_%s_TimingTimeCourse.mat',data_dir, TYPE, SVR, DAbasal, STIM), 'Ca_dur');


	%%%
	%%% Obtain max conc for save
	%%%

function max_val = max_concs(tname, sd, numCa_Durations, numToffsets_DA, Tstart, Tend, Toffset)
		max_val = zeros( numToffsets_DA, numCa_Durations );
		tid = find( strcmp( sd{1,1}.DataNames, tname ) );
		for j = 1: numCa_Durations;
			for i = 1: numToffsets_DA;
				time = sd{i,j}.Time - Toffset;
				data = sd{i,j}.Data(:,tid);
				id = find((time >= Tstart)&(time <= Tend));
				max_val(i,j) = max(data(id)) ;
			end
		end
end



