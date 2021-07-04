%%
%% 2D plot
%%

% Init
clear;
addpath('./model');
addpath('./funcs');
addpath('./funcs2');

init_font;
fprintf('\n');

AC_basal = 0.3; %
AC_dip   = 0.7; %
T1_2     = 0.5; %


flag_competitive 		= 0;% 0 or 1;
flag_Gi_sequestrated_AC = 1;
flag_optoDA 			= 0;
flag_duration 			= -1;

targ     = {'RGS' ,'D2R'};

data_dir = 'data';
mask_th  = 0.001;

mconc = {};
for j = 1:numel(targ);
	mconc{j} = 10.^[-1:0.025:1];
end

DAbasals1 = 2.^[-2:2] * 0.5;
DAdips1   = ones(size(DAbasals1)) * 0.05;
DAdips2   = 2.^[-2:2] * 0.05;
DAbasals2 = ones(size(DAdips2)) * 0.5;

DAbasals = {DAbasals1, DAbasals2};
DAdips   = {DAdips1  , DAdips2};
titles   = {'ACbasal', 'ACdip'};

%%
%%
for k = 1:numel(DAbasals);

	[fig1{k}, ax1{k}] = prep_plot_panel( targ, mconc, titles{k} );
	[fig2{k}, ax2{k}] = prep_plot_panel( targ, mconc, titles{k} );
	[fig3{k}, ax3{k}] = prep_plot_panel( targ, mconc, titles{k} );
	Icol = (1:numel(DAbasals{k}))/max(numel(DAbasals{k}));

	for i = 1:numel(DAbasals{k});

		DAbasal = DAbasals{k}(i);
		DAdip   = DAdips{k}(i);

		% Load
		Targ_dir = sprintf('%s/2D_DAbasal_%g_DAdip_%g', data_dir, DAbasal, DAdip);
		FILENAME =  sprintf('%s/compet_%g_%s_%s.mat', Targ_dir, flag_competitive, targ{1}, targ{2});
		load(FILENAME);

		plot_sim1(ax1{k}, targ, mconc, AC_dip_sim, AC_basal_sim, AC_t_sim, AC_basal, AC_dip )
		contour(ax1{k}, mconc{1}, mconc{2},  AC_basal_th', [AC_basal AC_basal],':','LineWidth',2, 'Color',[0,0,Icol(i)]);

		plot_sim2(ax2{k}, targ, mconc, AC_dip_sim, AC_basal_sim, AC_t_sim, AC_basal, AC_dip )
		contour(ax2{k}, mconc{1}, mconc{2},  AC_dip_th', [AC_dip AC_dip],':','LineWidth',2, 'Color',[0,Icol(i)/2,Icol(i)]);

		mask = ((AC_dip_sim - AC_basal_sim) > mask_th);

		plot_sim_t(ax3{k}, targ, mconc, AC_t_sim,  T1_2, mask )
		contour(ax3{k}, mconc{1}, mconc{2},  AC_t_th', [T1_2 T1_2],':','LineWidth',2, 'Color',[Icol(i),0,0]);

	end

	plot_standard_conc(ax1{k}, mconc);
	plot_standard_conc(ax2{k}, mconc);
	plot_standard_conc(ax3{k}, mconc);

end
%%
%%


%%%
%%% Functions
%%%

function [fig, ax] = prep_plot_panel(targs, mconc, t_title )
	xminmax = [ min(mconc{1}) , max(mconc{1}) ];
	yminmax = [ min(mconc{2}) , max(mconc{2}) ];
	zminmax = [ 0, 1.0 ];
	[fig, ax] = panel_prep4(xminmax, yminmax, zminmax, targs{1}, targs{2});
	title(ax,  t_title);
	hold on;
end

function plot_sim1(ax, targ, mconc, AC_dip_sim, AC_basal_sim, AC_t_sim, AC_basal, AC_dip )
	intensity = 0.1; %0-1

	mymap = [1 1 1;0 0.5 1;0 0 1;1 0 0];
	colormap(ax, mymap);
%	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', 0.33*(AC_dip_sim > AC_dip)', [0 1]);
%	im1.AlphaData = intensity;
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', 0.66*(AC_basal_sim < AC_basal)', [0 1]);
	im1.AlphaData = intensity;
end


function plot_sim2(ax, targ, mconc, AC_dip_sim, AC_basal_sim, AC_t_sim, AC_basal, AC_dip )
	intensity = 0.1; %0-1

	mymap = [1 1 1;0 0.5 1;0 0 1;1 0 0];
	colormap(ax, mymap);
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', 0.33*(AC_dip_sim > AC_dip)', [0 1]);
	im1.AlphaData = intensity;
end


function plot_sim_t(ax, targ, mconc, AC_t_sim,  T1_2 , mask )

	intensity = 0.1; %0-1

	mymap = [1 1 1;0 0.5 1;0 0 1;1 0 0];
	colormap(ax, mymap);
	area = (AC_t_sim < T1_2) .* mask;
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', area', [0 1]);
	im1.AlphaData = intensity;

end


function ax = plot_standard_conc(ax, mconc)
	xminmax = [ min(mconc{1}) , max(mconc{1}) ];
	yminmax = [ min(mconc{2}) , max(mconc{2}) ];
	
	plot(ax, xminmax, [1 1], 'k:');
	plot(ax, [1 1], yminmax, 'k:');
end


