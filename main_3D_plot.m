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


%	save(FILENAME,'model','params','species','targs',...
%		'mult_concs','default_conc','concs','nums', ...
%		't_half_sim','io_sim','idip_sim',...
%		'initial_concs');


	mconcs{1} 		= mult_concs;
	mconcs{2} 		= mult_concs;
	mconcs{3} 		= mult_concs;

% 	targs = {'RGS','AC1','D2R'};

	mRGS = initial_concs{1};
	mAC  = initial_concs{2};
	mD2R = initial_concs{3};

	[ io_theory, idip_theory, t_half_theory ] = theory(mD2R, mAC, mRGS, params);

%%
%% 3D plot
%%

	T1_2  = 0.5;  %
	Io    = 0.7; %
	Idip  = 0.3; %

	T_T    = (t_half_theory     < T1_2);
	T_S    = (t_half_sim < T1_2);
	Io_T   = (io_theory        > Io );
	Io_S   = (io_sim           > Io );
	Idip_T = (idip_theory    < Idip );
	Idip_S = (idip_sim       < Idip );

	Empty  = idip_sim * 0;

%%
%% Simulation results
%%

%% Io, Idip

	col = { 'blue', [0 0.5 1], [0 0.25 1] };
	TITLE = 'Sim_Io_Idip';

	dot_line_face = [2,3,5];
	[fig, ax] = plot_3D_panel(Io_S, Idip_S, targs, mconcs,  dot_line_face, col);
	view(ax,[-30 30]);
	savefig(fig, sprintf('%s/%s_1.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_1.tif', img_dir, TITLE),'-dtiff','-painters','-r300');

	dot_line_face = [2,4,5];
	[fig, ax] = plot_3D_panel(Io_S, Idip_S, targs, mconcs, dot_line_face, col);
	view(ax,[60 30]);
	savefig(fig, sprintf('%s/%s_2.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_2.tif', img_dir, TITLE),'-dtiff','-painters','-r300');


%% T1_2

	col = { 'red', [1 1 1], [1 1 1] };
	TITLE = 'Sim_T1_2';

	dot_line_face = [2,3,5];
	[fig, ax] = plot_3D_panel(T_S, Empty, targs, mconcs,  dot_line_face, col);
	view(ax,[-30 30]);
	savefig(fig, sprintf('%s/%s_1.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_1.tif', img_dir, TITLE),'-dtiff','-painters','-r300');

	dot_line_face = [2,4,5];
	[fig, ax] = plot_3D_panel(T_S, Empty, targs, mconcs, dot_line_face, col);
	view(ax,[60 30]);
	savefig(fig, sprintf('%s/%s_2.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_2.tif', img_dir, TITLE),'-dtiff','-painters','-r300');


%%
%% Analytical solution
%%

%% Io, Idip

	col = { 'blue', [0 0.5 1], [0 0.25 1] };
	TITLE = 'Theo_Io_Idip';

	dot_line_face = [2,3,5];
	[fig, ax] = plot_3D_panel(Io_T, Idip_T, targs, mconcs, dot_line_face, col);
	view(ax,[-30 30]);
	savefig(fig, sprintf('%s/%s_1.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_1.tif', img_dir, TITLE),'-dtiff','-painters','-r300');

	dot_line_face = [2,4,5];
	[fig, ax] = plot_3D_panel(Io_T, Idip_T, targs, mconcs, dot_line_face, col);
	view(ax,[60 30]);
	savefig(fig, sprintf('%s/%s_2.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_2.tif', img_dir, TITLE),'-dtiff','-painters','-r300');


%% T1_2

	col = { 'red', [1 1 1], [1 1 1] };
	TITLE = 'Theo_T1_2';

	dot_line_face = [2,3,5];
	[fig, ax] = plot_3D_panel(T_T, Empty, targs, mconcs,  dot_line_face, col);
	view(ax,[-30 30]);
	savefig(fig, sprintf('%s/%s_1.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_1.tif', img_dir, TITLE),'-dtiff','-painters','-r300');

	dot_line_face = [2,4,5];
	[fig, ax] = plot_3D_panel(T_T, Empty, targs, mconcs, dot_line_face, col);
	view(ax,[60 30]);
	savefig(fig, sprintf('%s/%s_2.fig', img_dir, TITLE));
	print(fig, sprintf('%s/%s_2.tif', img_dir, TITLE),'-dtiff','-painters','-r300');



