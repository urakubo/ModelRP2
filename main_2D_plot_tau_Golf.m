%%
%%
%%

	%% Init

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	init_font;

	fprintf('\n');

	T1_2     = 0.5; %
	AC_basal = 0.3; %
	AC_dip   = 0.7; %

	flag_competitive 		= 1;% 0 or 1;
	targs = {'tau_Golf','RGS'};
	data_dir = 'data';

	TITLE = sprintf('2D_Compet_%g_tau_Golf', flag_competitive);
	FILENAME =  sprintf('%s/%s_%s_%s.mat', data_dir, TITLE, targs{1}, targs{2});
	load(FILENAME);


	%% 2D plot

	[fig, ax] = prep_plot_panel(targs, mconc, 'ACbasal and ACdip' );
	plot_sim1(ax, targs, mconc, AC_dip_sim, AC_basal_sim, AC_t_sim, AC_basal, AC_dip,  T1_2 )
	plot_standard_conc(ax, mconc);

	[fig, ax_t] = prep_plot_panel(targs, mconc, ' T1/2' );
	plot_sim2(ax_t, targs, mconc, AC_t_sim,  T1_2 )
	plot_standard_conc(ax_t, mconc);


	%% Theory

	%% tau_Golf

	kon_AC_Golf  = params{'kon_AC_Golf','Obj'}.Value ;
	koff_AC_Golf = params{'koff_AC_Golf','Obj'}.Value;
	Golf         = species{'Golf','Obj'}.InitialAmount;
	tau_standard = 1./(kon_AC_Golf * Golf + koff_AC_Golf);
	mult_1   =   ( 1 / log(2) ) / tau_standard;
	mult_1_2 = ( 0.5 / log(2) ) / tau_standard;
	
	yminmax = [ min(mconc{2}) , max(mconc{2}) ];
%	plot(ax_t,[mult_1 mult_1], yminmax, ':','LineWidth',2,'Color',[0,0.5,0]);
	plot(ax_t,[mult_1_2 mult_1_2], yminmax, ':','LineWidth',2,'Color',[0,0.5,0]);


	%% ACbasal, ACdip, T1_2

	mD2R = species{'D2R','Obj'}.InitialAmount;
	mAC  = species{'AC1','Obj'}.InitialAmount;
	mRGS = species{'RGS','Obj'}.InitialAmount;
	mGi  = species{'Gi_Gbc','Obj'}.InitialAmount;
	mGolf= species{'Golf','Obj'}.InitialAmount;
	mRGS = mconc{2} * mRGS;

	[ AC_basal_theory, AC_dip_theory, t_half_theory ] = theory(flag_competitive, mD2R, mAC, mRGS, mGi, mGolf, params);
	
	AC_basal   = obtain_x_crossing(mconc{2}, AC_basal_theory, 0.3);
	AC_dip     = obtain_x_crossing(mconc{2}, AC_dip_theory  , 0.7);
	t_half_1_2 = obtain_x_crossing(mconc{2}, t_half_theory  , 0.5);
	t_half_1   = obtain_x_crossing(mconc{2}, t_half_theory  , 1.0);
	
	xminmax = [ min(mconc{1}) , max(mconc{1}) ];
	plot(ax,  xminmax, [1 1] * AC_basal   , 'b:','LineWidth',2);
	plot(ax,  xminmax, [1 1] * AC_dip     , ':' ,'LineWidth',2,'Color',[0,0.5,1]);
	plot(ax_t,xminmax, [1 1] * t_half_1_2 , 'r:','LineWidth',2);
%	plot(ax_t,xminmax, [1 1] * t_half_1   , 'r:','LineWidth',2);


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

function plot_sim1(ax, targ, mconc, AC_dip_sim, AC_basal_sim, AC_t_sim, AC_basal, AC_dip, T1_2 )

	intensity = 0.2; %0-1

	mymap = [1 1 1;0 0.5 1;0 0 1;1 0 0];
	colormap(ax, mymap);
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', 0.33*(AC_dip_sim > AC_dip)', [0 1]);
	im1.AlphaData = intensity;
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', 0.66*(AC_basal_sim < AC_basal)', [0 1]);
	im1.AlphaData = intensity;

end

function plot_sim2(ax, targ, mconc, AC_t_sim,  T1_2 )
	intensity = 0.2; %0-1

	mymap = [1 1 1;0 0.5 1;0 0 1;1 0 0];
	colormap(ax, mymap);
%	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', (AC_t_sim < 1.0)', [0 1]);
%	im1.AlphaData = 0.08;
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', (AC_t_sim < T1_2)', [0 1]);
	im1.AlphaData = 0.2;
end



function ax = plot_standard_conc(ax, mconc)

	xminmax = [ min(mconc{1}) , max(mconc{1}) ];
	yminmax = [ min(mconc{2}) , max(mconc{2}) ];
	
	plot(ax, xminmax, [1 1], 'k:');
	plot(ax, [1 1], yminmax, 'k:');
end


