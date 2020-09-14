%%
%% Please run "main_3D_sim.m" beforehand.
%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	TITLE = '3D';
	data_dir = 'data';
	img_dir  = 'imgs';
	load( sprintf('%s/%s.mat', data_dir, TITLE));

% 'model','params','species','targs',...
% 'mult_concs','default_conc','concs','nums', ...
% 't_half_simulation','t_half_simulation','i_simulation',...
% 'initial_concs');

	mconcs{1} 		= mult_concs;
	mconcs{2} 		= mult_concs;
	mconcs{3} 		= mult_concs;

% 	targs = {'RGS','AC1','D2R'};

	mRGS = initial_concs{1};
	mAC  = initial_concs{2};
	mD2R = initial_concs{3};

	[ i_theory, t_half_theory ] = theory(mD2R, mAC, mRGS, params);

%%
%% 3D plot
%%

	T1_2    = 0.5  ; % 0.5
	Io = 0.75 ; %0.75; % 0.5

	T_T = (t_half_theory     < T1_2);
	T_S = (t_half_simulation < T1_2);
	A_T = (i_theory          > Io );
	A_S = (i_simulation      > Io );


%%
%% Simulation results
%%

	dot_line_face = [2,3,5];
	TITLE = 'Simulation';
	[fig, ax] = plot_3D_panel(T_S, A_S, targs, mconcs,  dot_line_face);
	view(ax,[-30 30]);
	savefig(fig, sprintf('%s/%s_1.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_1.tif', img_dir, TITLE),'-dtiff','-painters','-r300');


	dot_line_face = [2,4,5];
	[fig, ax] = plot_3D_panel(T_S, A_S, targs, mconcs, dot_line_face);
	view(ax,[60 30]);
	savefig(fig, sprintf('%s/%s_2.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_2.tif', img_dir, TITLE),'-dtiff','-painters','-r300');

%%
%% Analytical solution
%%

	TITLE = 'Theory';
	dot_line_face = [2,3,5];
	[fig, ax] = plot_3D_panel(T_T, A_T, targs, mconcs, dot_line_face);
	view(ax,[-30 30]);
	savefig(fig, sprintf('%s/%s_1.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_1.tif', img_dir, TITLE),'-dtiff','-painters','-r300');


	dot_line_face = [2,4,5];
	[fig, ax] = plot_3D_panel(T_T, A_T, targs, mconcs, dot_line_face);
	view(ax,[60 30]);
	savefig(fig, sprintf('%s/%s_2.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_2.tif', img_dir, TITLE),'-dtiff','-painters','-r300');


