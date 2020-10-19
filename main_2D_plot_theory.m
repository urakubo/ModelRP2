%%%%
%%%% Init
%%%%

	rmpath('./funcs');
	clear;

	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	T1_2  = 0.5;
	Io    = 0.7;
	Idip  = 0.3;
	grey = [1,1,1]*0.5;

	check = 0;
	[model, species, params, Toffset] = msn_setup(check);

%%%
%%%

	tmp = 10.^[-1:0.1:2];
	tmp = 10.^[-1:0.05:1];
	tmp = 10.^[-1:0.025:2];

	targs = {'D2R','AC1','RGS'};
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
	D2R_AC1_RGS = obtain_init_concs_2D(species, targ, conc, targs);
	D2R = D2R_AC1_RGS{1};
	AC1 = D2R_AC1_RGS{2};
	RGS = D2R_AC1_RGS{3};
	[ io_theory, idip_theory, t_half_theory ] = theory(D2R, AC1, RGS, params);


%%
%% 2D plot 
%%
	xmconc = mult_conc{1} ;
	ymconc = mult_conc{2} ;
	
	[fig0, ax0] = fig_prep2(targ, xmconc, ymconc, 'i dip');
	[fig1, ax1] = fig_prep2(targ, xmconc, ymconc, 'i o');
	[fig2, ax2] = fig_prep2(targ, xmconc, ymconc, 't half');

	area = (io_theory > Io) .* (idip_theory < Idip);
	plot_heatmap(fig2, ax2, xmconc, ymconc, area');

	contour(ax0, xmconc, ymconc, idip_theory', [Idip Idip], ':', 'LineWidth', 4, 'Color', [0 0.5 1]);
	contour(ax1, xmconc, ymconc, io_theory', [Io Io], 'b:', 'LineWidth', 4);
	contour(ax2, xmconc, ymconc, t_half_theory', [T1_2 T1_2], 'r:', 'LineWidth', 4);

	plot_standard_conc(ax0, xmconc, ymconc);
	plot_standard_conc(ax1, xmconc, ymconc);
	plot_standard_conc(ax2, xmconc, ymconc);


%%
%% Asymptote
%%
	RGS    = conc{1};
	AC     = species{'AC1','Obj'}.InitialAmount;
	stdD2R = species{'D2R','Obj'}.InitialAmount;

	D2R   = theory_asymptote(RGS, Idip, params, AC, 'Idip_1');
	D2R_2 = theory_asymptote(RGS, Idip, params, AC, 'Idip_2');
	plot(ax0, xmconc, D2R./stdD2R   ,'--','LineWidth',2, 'Color', grey);
	plot(ax0, xmconc, D2R_2./stdD2R ,'--','LineWidth',2, 'Color', grey);

	D2R   = theory_asymptote(RGS, Io, params, AC, 'Io_1');
	D2R_2 = theory_asymptote(RGS, Io, params, AC, 'Io_2');
	plot(ax1, xmconc, D2R./stdD2R   ,'--','LineWidth',2, 'Color', grey);
	plot(ax1, xmconc, D2R_2./stdD2R ,'--','LineWidth',2, 'Color', grey);

	D2R   = theory_asymptote(RGS, T1_2, params, AC, 'T1_2');
	plot(ax2, xmconc, D2R./stdD2R,'--','LineWidth',2 , 'Color', grey);


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


