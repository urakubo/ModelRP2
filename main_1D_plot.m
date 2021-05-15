%%
%% main_1D_plot
%%

	clear;
	addpath('./model') ;
	addpath('./funcs') ;
	addpath('./funcs2');
	init_font;


	flag_competitive 		= 1;
	flag_Gi_sequestrated_AC = 1;
	flag_optoDA 			= 0;
	flag_duration 			= -1;
	[model, species, params, container] = msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration);
	Toffset = container('Toffset_DA').Value;

	concs1 = 10.^[-1:0.1:1];
	concs2 = 10.^[-2:0.1:2];
	targs      = {'D2R'  ,'RGS'  ,'AC1'  ,'Gi_Gbc' ,'Golf'};
	mult_concs = {concs1 ,concs1 ,concs1 ,concs2   ,concs2};

	width = 1;

%{
	targs = {'Gi_Gbc'};
	mult_concs = 10.^[-2:0.1:2];
	width = 1.15;
%}

	fig = figure('Name',sprintf('Competitive %g',flag_competitive));
	fig.Position = fig.Position.*[1, 0.5, 1.5, 1.3];


	for i = 1:numel(targs);

		concs = mult_concs{i};
		targ  = targs{i};
		fprintf('Target: %s \n', targ);

		%% Sim
		[AC_basal_sim, AC_dip_sim, AC_t_sim] =  sim_1D(targ, concs, species, model, Toffset);

		%% Theory
		[D2Rtot, RGStot, ACtot, Gi_Gbctot, Golftot] = obtain_init_concs_1D( species, targ, concs );
		
		[ AC_basal_th, AC_dip_th, AC_t_th ] = theory(flag_competitive, D2Rtot, ACtot, RGStot, Gi_Gbctot, Golftot, params);

		%% Plot
		xrange = [min(concs), max(concs)];

		yrange = [0,120];
		col    = [0,0,1];
		whi    = [1,1,1];

		a1 = prep_plot_(fig, xrange, yrange, targ, 'AC_act basal (%Total)', i, width);
		plot_paint(a1, concs,  (AC_basal_sim < 0.30),  yrange, col*0.2+whi*0.8)
		plot(a1,   concs, AC_basal_sim*100, 'k-', 'LineWidth',2);
		plot(a1,   concs, AC_basal_th*100, ':', 'LineWidth',2, 'Color', col);
		plot_decoration(a1, xrange, yrange);

		col = [0, 0.5, 1];
		a3 = prep_plot_(fig, xrange, yrange, targ, 'AC_act_dip (%Total)', i+5, width);
		plot_paint(a3, concs,  (AC_dip_sim > 0.70),  yrange, col*0.2+whi*0.8)
		plot(a3,   concs, AC_dip_sim*100, 'k-', 'LineWidth',2);
		plot(a3,   concs, AC_dip_th*100, ':', 'LineWidth',2, 'Color', col);
		plot_decoration(a3, xrange, yrange)

		if strcmp(targ, 'Golf')
			kon_AC_GolfGTP  = params{'kon_AC_GolfGTP','Obj'}.Value;
			koff_AC_GolfGTP = params{'koff_AC_GolfGTP','Obj'}.Value;
			Kd_AC_Golf      = koff_AC_GolfGTP / kon_AC_GolfGTP;
			Golf 			= Golftot ./ Kd_AC_Golf;
			max_AC_Golf 	= Golf ./ (1+Golf);
			a5 = prep_plot_(fig, xrange, yrange, targ, 'max_AC_Golf (%Total)', i+10, width);
			plot(a5,   concs, max_AC_Golf*100, 'k-', 'LineWidth',2);
			plot(a5, [1 1], yrange, 'k:', 'LineWidth', 0.5);
			id_Golf = find(Golftot == species{'Golf','Obj'}.InitialAmount); % 0.3750
			title( a5, max_AC_Golf(id_Golf) )
		end

		yrange = [0.01,10];
		col = [1,0.8,0.8];
		a2 = prep_plot_(fig, xrange, yrange,  targ, '(s)', i+15, width);
		plot_paint(a2, concs,  (AC_t_sim < 0.5),  yrange, col)
		plot(a2, concs, AC_t_sim, 'k-', 'LineWidth',2);
		plot(a2, concs, AC_t_th , 'r:', 'LineWidth',2);
		plot_decoration(a2, xrange, yrange);
		prep_ylog(a2);

	end


%%%
%%%

function plot_paint(a, xx, paint_area,  yrange, color)

	id = find(paint_area);
	if isempty(id) == 0
		id = rectangle(a,'Position',[(min(xx(id))),yrange(1), ...
			(max(xx(id)))-(min(xx(id))), yrange(2)-yrange(1)], ...
			'EdgeColor','none','FaceColor', color );
		id.Clipping = 'on';
	end
end


function ax = prep_plot_short(fig, xx, zz , xtitle, ytitle, i, width)
	ii = i - 1;
	row = floor(ii / 5);
	col = mod(ii, 5);
	ax = axes(fig, 'Position',[(0.1+col*0.18), (0.7-row*0.3),  0.1 * width,  0.18]); %%

	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	set(gca, 'XScale', 'log');
	set(ax,'XTick',[0.01,0.1,1,10,100]);
	xlim(xx);
	ylim(zz);
	set(gca, 'XTickLabel',  num2str( get(gca,'XTick')' ,'%-g'));
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ytitle, 'Interpreter', 'none');
	ax.Clipping = 'on';
	ax.ClippingStyle = 'rectangle';
end


function ax = prep_plot_(fig, xx, zz , xtitle, ytitle, i, width)
	ii = i - 1;
	row = floor(ii / 5);
	col = mod(ii, 5);
	ax = axes(fig, 'Position',[(0.1+col*0.18), (0.8-row*0.23),  0.1 * width,  0.13]); %%

	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	set(gca, 'XScale', 'log');
	set(ax,'XTick',[0.01,0.1,1,10,100]);
	xlim(xx);
	ylim(zz);
	set(gca, 'XTickLabel',  num2str( get(gca,'XTick')' ,'%-g'));
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ytitle, 'Interpreter', 'none');
	ax.Clipping = 'on';
	ax.ClippingStyle = 'rectangle';
end


function [iD2R, iRGS, iAC1, iGi_Gbc, iGolf] = obtain_init_concs_1D( species, targ, mult_concs )

	iD2R = ones(size(mult_concs)) *  species{'D2R','Obj'}.InitialAmount;
	iRGS = ones(size(mult_concs)) *  species{'RGS','Obj'}.InitialAmount;
	iAC1 = ones(size(mult_concs)) *  species{'AC1','Obj'}.InitialAmount;
	iGolf= ones(size(mult_concs)) *  species{'Golf','Obj'}.InitialAmount;
	iGi_Gbc = ones(size(mult_concs)) *  species{'Gi_Gbc','Obj'}.InitialAmount;
	% fprintf('obtain_init_concs, %s \n',  targ);
	% fprintf('iD2R, iRGS, iAC1: %g, %g, %g \n', iD2R(1,1), iRGS(1,1), iAC1(1,1));
	switch targ
		case 'D2R'
			iD2R = mult_concs .* iD2R;
		case 'RGS'
			iRGS = mult_concs .* iRGS;
		case 'AC1'
			iAC1 = mult_concs .* iAC1;
		case 'Golf'
			iGolf = mult_concs .* iGolf;
		case 'Gi_Gbc'
			iGi_Gbc = mult_concs .* iGi_Gbc;
		otherwise
			fprintf("Error: %s\n", targ);
	end;

end

function plot_decoration(ax, xrange, yrange)
	plot(ax, [1 1], yrange, 'k:', 'LineWidth', 0.5);
	plot(ax, xrange, [yrange(1) yrange(1)], 'k-');
	plot(ax, [xrange(1) xrange(1)], yrange, 'k-');
end

function prep_ylog(ax)
	set(ax, 'YScale', 'log');
	set(ax, 'YTick', 10.^(-2:1));
	set(ax, 'YTickLabel',  num2str( get(gca,'YTick')' ,'%g'));
end


