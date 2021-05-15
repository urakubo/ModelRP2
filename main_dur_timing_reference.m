
	%%
	%%
	rmpath('./models2');
	clear;

	TYPE = 'D2'; DAbasal = 0.5; STIM = 'Dip';
%	TYPE = 'D1'; DAbasal = 0.0; STIM = 'Burst';

	SVR  = 30  ; % r = 0.1; % Spine

	data_dir ='data/Timing/';
	img_dir ='imgs/';
	addpath('./funcs');
	addpath('./models');
	
	%%
	%%
	
	data_dir = sprintf('data/%s/', TYPE);
	mkdir(data_dir);
	
	%%
	%%

	switch TYPE
   		case 'D1'
      		Ca_dur_prof  = [  2,  1,  0.5, 0.1];
			Ca_Durations = (1:1:20)/10;
			Ca_Durations = [Ca_Durations, Ca_dur_prof];
			Ca_Durations = unique(Ca_Durations, 'sorted');
   		case 'D2'
      		Ca_dur_prof  = [  1,   0.5 ,  0.2];
			Ca_Durations = (1:0.5:10)/10;
			Ca_Durations = [Ca_Durations, Ca_dur_prof];
			Ca_Durations = unique(Ca_Durations, 'sorted');
		end


	Toffsets_DA  = [-6, -4:0.4:4, 6];

	numCa_Durations = numel(Ca_Durations);
	numToffsets_DA  = numel(Toffsets_DA);


	%%
	%% Model specification
	%%
	stop_time = 2100;

	%%
	Toffset_VGCC  = 1910;
	Toffset_DA    = 1910;
	Toffset       = Toffset_DA;
	Tstart        = -30;
	Tend          =  150;
	T_duration_Ca = 0;

	%%
	%% MSN
	%%

	init_species = InitSpecies(SVR, DAbasal);
	init_params  = InitParams();
	[model, species, params] = DefineModel(init_species, init_params, stop_time);
	InitReacs(model, species, params, TYPE);

	switch TYPE
   		case 'D1'
      		set(species{'D2R','Obj'}, 'InitialAmount', 0);
      		set(species{'A2AR','Obj'}, 'InitialAmount', 0);
   		case 'D2'
      		set(species{'D1R','Obj'}, 'InitialAmount', 0);
      		set(species{'AC5sub0','Obj'}, 'InitialAmount', 0);
      		set(species{'AC5sub1','Obj'}, 'InitialAmount', 0);
      		set(species{'AC5sub2','Obj'}, 'InitialAmount', 0);
		end
	switch STIM
   		case 'Burst'
			run('event_DA_Increase_dur.m');
   		case 'Dip'
      		run('event_DA_Decrease_dur.m');
	end


	%%
	%% Simulation
	%%
	sd   = cell(numToffsets_DA, numCa_Durations);
	for j = 1:numCa_Durations;
		fprintf('Ca_Durations: %d / %d \n', j, numCa_Durations );
		durCa.Value = Ca_Durations(j);
		for i = 1:numToffsets_DA;
			switch TYPE
   				case 'D1'
   					tDA.Value = Toffsets_DA(i) + Toffset_VGCC;
   				case 'D2'
					tDA.Value = Toffsets_DA(i) + Toffset_VGCC;
			end
			sd{i,j} = sbiosimulate(model);
		end;
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
	    TNAME2 = {	'Ct',	'cAMP' };
		YMAX2  = {	1.5,	4 };
	end


	%%%
	%%% Plot timing dependence
	%%%
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



