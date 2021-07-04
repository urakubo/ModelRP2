%%%%
%%%% Init
%%%%

	rmpath('./funcs');

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	init_font;
	fprintf('\n');

	T1_2     = 0.5;
	AC_basal = 0.3;
	AC_dip   = 0.7;
	grey = [1,1,1]*0.5;

%%%
	flag_competitive 		= 1;
	flag_Gi_sequestrated_AC = 1;
	flag_optoDA 			= 0;
	flag_duration 			= -1;
	[model, species, params, container] = ...
		msn_setup(flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration);

%%%
	tmp = 10.^[-1:0.025:2];
	targs = {'D2R', 'AC1' ,'RGS' ,'Gi_Gbc' ,'Golf'};
	dim   = [3,1];
	targ = targs(dim);

	conc = {};
	mconc = {};
	for i = 1:numel(dim);
		mult_conc{i} = tmp;
		default_conc = species{targ{i},'Obj'}.InitialAmount;
		conc{i}		 = mult_conc{i} .* default_conc;
		fprintf('Standard conc %s: %g uM \n', targ{i}, default_conc );
	end

	% Theory
	targ_concs = init_concs_2D(species, targ, conc, targs);
	[ AC_basal_th, AC_dip_th, AC_t_th ] = ...
		theory(flag_competitive, targ_concs{1}, targ_concs{2}, targ_concs{3}, targ_concs{4}, targ_concs{5}, params);


%%
%% 2D plot 
%%
	xmconc = mult_conc{1} ;
	ymconc = mult_conc{2} ;
	
	[fig0, ax0] = fig_prep2(targ, xmconc, ymconc, 'AC dip');
	[fig1, ax1] = fig_prep2(targ, xmconc, ymconc, 'AC basal');
	[fig2, ax2] = fig_prep2(targ, xmconc, ymconc, 't1/2');

	area = (AC_basal_th < AC_basal) .* (AC_dip_th > AC_dip);
	plot_heatmap(fig2, ax2, xmconc, ymconc, area');

	contour(ax0, xmconc, ymconc, AC_dip_th'   , [1 1]*AC_dip   , ':' , 'LineWidth', 4, 'Color', [0 0.5 1]);
	contour(ax1, xmconc, ymconc, AC_basal_th' , [1 1]*AC_basal , 'b:', 'LineWidth', 4);
	contour(ax2, xmconc, ymconc, AC_t_th'     , [1 1]*T1_2     , 'r:', 'LineWidth', 4);

	plot_standard_conc(ax0, xmconc, ymconc);
	plot_standard_conc(ax1, xmconc, ymconc);
	plot_standard_conc(ax2, xmconc, ymconc);


%%
%% Asymptote
%%
	RGS    = conc{1};
	ACtot  = species{'AC1','Obj'}.InitialAmount;
	D2Rtot = species{'D2R','Obj'}.InitialAmount;
	Golftot = species{'Golf','Obj'}.InitialAmount;

	D2R  = theory_asymptote(RGS, params, ACtot, Golftot, 'ACdip', flag_competitive);
	D2R_1 = D2R(1,:);
	D2R_2 = D2R(2,:);
	plot(ax0, xmconc, D2R_1./D2Rtot ,'--','LineWidth',2, 'Color', grey);
	plot(ax0, xmconc, D2R_2./D2Rtot ,'--','LineWidth',2, 'Color', grey);

	D2R = theory_asymptote(RGS, params, ACtot, Golftot, 'ACbasal', flag_competitive);
	D2R_1 = D2R(1,:);
	D2R_2 = D2R(2,:);
	plot(ax1, xmconc, D2R_1./D2Rtot ,'--','LineWidth',2, 'Color', grey);
	plot(ax1, xmconc, D2R_2./D2Rtot ,'--','LineWidth',2, 'Color', grey);

	D2R   = theory_asymptote(RGS,  params, ACtot, Golftot, 'T1_2', flag_competitive);
	plot(ax2, xmconc, D2R./D2Rtot,'--','LineWidth',2 , 'Color', grey);


%%%
%%% Functions
%%%

function plot_heatmap(fig, ax, xmconcs, ymconcs, i_theory);
	Io   = [0.70, 0.98]; 
	Io_line_color = 'None'; % [0, 0, 1];
	Io_panel_color = [0.9, 0.9, 1;
				0.85, 0.85, 1;
				0.8, 0.8, 1];

	xminmax = [ min(xmconcs) , max(xmconcs) ];
	yminmax = [ min(ymconcs) , max(ymconcs) ];
	colormap(fig, Io_panel_color);
	caxis([min(Io), max(Io)]);

	[M,c] = contourf(ax, xmconcs, ymconcs, i_theory, Io, 'EdgeColor', Io_line_color);
end


function [fig, ax] = fig_prep2(targs, xmconcs, ymconcs, t_title)
	xminmax = [ min(xmconcs) , max(xmconcs) ];
	yminmax = [ min(ymconcs) , max(ymconcs) ];
	zminmax = [ 0, 1.0 ];
	[fig, ax] = panel_prep4(xminmax, yminmax, zminmax, targs{1}, targs{2});
	title(ax,  t_title);
	hold on;
end


function plot_standard_conc(ax, xmconcs, ymconcs);
	xminmax = [ min(xmconcs) , max(xmconcs) ];
	yminmax = [ min(ymconcs) , max(ymconcs) ];
	plot(ax, xminmax, [ 1, 1 ], 'k:');
	plot(ax, [ 1, 1 ], yminmax, 'k:');
end


