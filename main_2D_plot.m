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

T1_2     = 0.5; %
AC_basal = 0.3; %
AC_dip   = 0.7; %


flag_competitive 		=  0; % 0: non-competitive ; 1: competitive
flag_Gi_sequestrated_AC =  1; % 0: non-sequestrated; 1: sequestrated

data_dir = 'data';
TITLE = sprintf('2D_Compet_%g_Sequest_%g', flag_competitive, flag_Gi_sequestrated_AC);


%%
%% 2D plot
%%

targs = {'D2R', 'AC1' ,'RGS' ,'Gi_Gbc' ,'Golf'};
dims = { [3,1], [2,1], [2,3], [3,5] };


for  i = 1:numel(dims);

	FILENAME =  sprintf('%s/%s_%g_%g.mat', data_dir, TITLE, dims{i}(1), dims{i}(2));
	load(FILENAME);
	targ = targs(dims{i});

	% Fig1
	%%{
	[fig, ax] = prep_plot_panel(targ, mconc, 'ACbasal and ACdip' );
	plot_sim1(ax, targ, mconc, AC_dip_sim, AC_basal_sim, AC_t_sim, AC_basal, AC_dip, T1_2 )
	contour(ax, mconc{1}, mconc{2},  AC_basal_th', [AC_basal AC_basal],'b:','LineWidth',2);
	contour(ax, mconc{1}, mconc{2},  AC_dip_th', [AC_dip AC_dip],':','LineWidth',2,'Color',[0,0.5,1]);
	plot_standard_conc(ax, mconc);

	[fig, ax] = prep_plot_panel(targ, mconc, ' T1/2' );
	plot_sim2(ax, targ, mconc, AC_t_sim,  T1_2 )
	contour(ax, mconc{1}, mconc{2},  AC_t_th', [T1_2 T1_2],'r:','LineWidth',2);
	plot_standard_conc(ax, mconc);
	%%}



	%% Fig 6.
	%{
	if isequal(dims{i}, [3,1])
	
		lred = [1, 0.5, 0.5];
	
		[fig, ax] = prep_plot_panel(targ, mconc, 'Althgether' );
		alpha = 0.2;
		plot_sim3(ax, targ, mconc, idip_sim, io_sim, t_half_sim, Io, Idip, T1_2, alpha );
		% contour(ax, mconc{1}, mconc{2},  t_half_sim', [T1_2 T1_2],'-','Color',lred,'LineWidth',2);
		plot_standard_conc(ax, mconc);

		[fig, ax] = prep_plot_panel(targ, mconc, 'Althgether' );
		alpha = 0.1;
		plot_sim3(ax, targ, mconc, idip_sim, io_sim, t_half_sim, Io, Idip, T1_2, alpha );
		plot_standard_conc(ax, mconc);
		mults = {[1.0, 1.0], [0.5,0.5], [0.5, 4.0], [2.0, 0.5]};
		cols  = {  [1 1 1]*0.5, [0 1 0], [0 0 1], [1 0 0] };
		colsEdge  = {  'k', 'k', [0.5 0.5 1], [1 0.5 0.5] };
		sizes = [  1, 1, 1, 1 , 1  ] * 8 ;
		LW    = [  1, 1, 1, 1 , 1  ] * 0.75 ;
		for i = 1:numel(mults);
			plot(ax, mults{i}(1), mults{i}(2) , 'o', ...
				'MarkerFaceColor', cols{i}, ...
				'MarkerEdgeColor', colsEdge{i}, ...
				'LineWidth',  LW(i), ...
				'MarkerSize', sizes(i));
		end
		
		lRGS = 2.0 + 2.^[-4:0.5:2];
		lD2R = 0.5 + 2.^[-4:0.5:2];
		plot(ax, lRGS, lD2R, '-', 'LineWidth', 2,'Color', [1,1,1]*0.5);
		
	end
	%}
	%%

end


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
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', (AC_t_sim < T1_2)', [0 1]);
	im1.AlphaData = intensity;

end

function plot_sim3(ax, targ, mconc, AC_dip_sim, AC_basal_sim, AC_t_sim, AC_basal, AC_dip, T1_2, alpha )


	%{
	target_area1 = (AC_dip_sim > AC_dip)' .* (AC_basal_sim > AC_basal)' ;
	target_area2 = (AC_dip_sim < AC_dip)' .* (AC_basal_sim > AC_basal)' .* (AC_t_sim < T1_2)' ;
	target_area  = (target_area1 + target_area2) / 2;
	a = 0.85;
	b = 0.7;
	mymap = [1 1 1;a a 1;a b a];
	colormap(ax, mymap);
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', target_area, [0 1]);
	%}

	target_area1 = (AC_dip_sim > AC_dip)' .* (AC_basal_sim > AC_basal)' ;
	target_area2 = (AC_t_sim < T1_2)' ;
	mymap = [1 1 1;0 0 1;1 0 0];
	colormap(ax, mymap);
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', target_area2, [0 1]);
	im1.AlphaData = alpha;
	im1 = imagesc( ax, 'XData', mconc{1},'YData', mconc{2}, 'CData', 0.5*target_area1, [0 1]);
	im1.AlphaData = alpha;

end

function ax = plot_standard_conc(ax, mconc)

	xminmax = [ min(mconc{1}) , max(mconc{1}) ];
	yminmax = [ min(mconc{2}) , max(mconc{2}) ];
	
	plot(ax, xminmax, [1 1], 'k:');
	plot(ax, [1 1], yminmax, 'k:');
end


