%%
%% Init
%%
clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;

flag_optoDA      = 0;
flag_competitive = 0;
flag_duration    = 0.5;
[model, species, params, T_VGCC, T_DA] = msn_setup_TimeWindow(flag_competitive, flag_duration, flag_optoDA);

Toffset = T_VGCC.Value;
T_DA.Value = T_VGCC.Value + 0.5;

trange   = [-1,3];
trange2  = [-1,40];

ylegend  = '(uM)';
pm       = [-0.12, 1.2];

targs_plot  = {  'DA', 'DA_D2R',   'ACact', 'Ca', 'ActiveAC', 'AC_CaM',  'cAMP', 'Ct'};
yranges     = {pm*0.8,  pm*0.02,      pm, pm*1.5,    pm*0.05,  pm*0.1,    pm*2 , pm*0.4 };
xranges     = {trange,  trange,   trange, trange,     trange,   trange, trange2 , trange2};

targs = {{}};
colors  = {[1 1 1]*0 };
linew   = {2};
mults   = {1};

%%
%% Prep. figures
%%

a = {};
fig     = figure;
for i = 1:numel(targs_plot);
	a{i} = plot_prep(fig, xranges{i}, yranges{i}, targs_plot{i}, 'Time (s)', ylegend, i);
	hold on;
	plot(a{i}, xranges{i}, [0 0], 'k:');
	plot(a{i}, [0 0], [yranges{i}(2), yranges{i}(2)*0.8 - yranges{i}(1)*0.2], ...
	'r-','LineWidth',1);
end
yticks(a{1},[0 0.5]);

sd = sbiosimulate(model);
j = 1;
for i = 1:numel(targs_plot);
	[T, DATA] = obtain_profile(targs_plot{i}, sd, Toffset);
	plot(a{i}, T, DATA, '-', 'LineWidth', linew{j}, 'Color', colors{j});
end

%%
%%

function ax = plot_prep(fig, xx, zz ,titl, xtitle, ytitle, i)
	ii = i - 1;
	col = floor(ii / 3);
	row = mod(ii, 3);
	ax = axes(fig, 'Position',[(0.08+col*0.3), (0.75 - row*0.33),  0.15*1.5,  0.2]); %%

	ax.ActivePositionProperty = 'Position';

	title(titl,'interpreter','none');
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ytitle );
	xlim(xx);
	ylim(zz);
end

%%
%%

