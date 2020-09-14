%%%%
%%%% Init
%%%%

	rmpath('./funcs');
	clear;

	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	grey = [1,1,1]*0.5;
	T1_2 = 0.5;
	Io   = 0.75;

	check = 0;
	[model, species, params, Toffset] = msn_setup(check);

%%%
%%%
	dims = {'D2R','AC1','RGS'};
	xtarg = 'RGS';
	ytarg = 'D2R';
	targ = {xtarg, ytarg};
	

%	tmp = 10.^[-1:0.025:1];
	tmp = 10.^[-1:0.05:2];
%	tmp = 10.^[-1:0.1:2];

	for i = 1:3;
		mult_concs{i} = tmp;
		default_concs{i} = species{dims{i},'Obj'}.InitialAmount;
		fprintf('Original conc %s: %g uM \n', dims{i}, default_concs{i} );
	end
	default_concs = cell2table( default_concs, 'VariableNames', dims);
	mult_concs    = cell2table( mult_concs, 'VariableNames', dims);


	num  = [numel(mult_concs{1,targ{1}}), numel(mult_concs{1,targ{2}})];
	mAC  = ones(num) .* default_concs{1,'AC1'};
	mRGS = mult_concs{1,xtarg}' * ones(1,num(2)) .* default_concs{1,xtarg};
	mD2R = ones(num(1), 1) * mult_concs{1, ytarg}.* default_concs{1,ytarg};

	[ i_theory, t_half_theory ] = theory(mD2R, mAC, mRGS, params);

%%
%% 2D plot 
%%
	xmconcs = mult_concs{1, xtarg } ;
	ymconcs = mult_concs{1, ytarg } ;

	[fig1, ax1] = fig_prep2(targ, xmconcs, ymconcs, 'i Theory');
	[fig2, ax2] = fig_prep2(targ, xmconcs, ymconcs, 't1/2 Theory');

	plot_heatmap(fig2, ax2, xmconcs, ymconcs, i_theory');

	contour(ax1, xmconcs, ymconcs, i_theory', [Io Io], 'b:', 'LineWidth', 4);
	contour(ax2, xmconcs, ymconcs, t_half_theory', [T1_2 T1_2], 'r:', 'LineWidth', 4);

	plot_standard_conc(ax1, xmconcs, ymconcs);
	plot_standard_conc(ax2, xmconcs, ymconcs);


%%
%% Asymptote
%%
	RGS    = mRGS(:,1);
	AC     = default_concs{1,'AC1'};
	stdD2R = default_concs{1,'D2R'};
	
	D2R   = theory_asymptote(RGS, Io, params, AC, 'I1');
	D2R_2 = theory_asymptote(RGS, Io, params, AC, 'I2');
	plot(ax1, xmconcs, D2R./stdD2R   ,'--','LineWidth',2, 'Color', grey);
	plot(ax1, xmconcs, D2R_2./stdD2R ,'--','LineWidth',2, 'Color', grey);

	D2R   = theory_asymptote(RGS, T1_2, params, AC, 'T1_2');
	plot(ax2, xmconcs, D2R./stdD2R,'--','LineWidth',2 , 'Color', grey);


%%%
%%% Functions
%%%

function plot_heatmap(fig, ax, xmconcs, ymconcs, i_theory);
	Io   = [0.75, 0.98]; 
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


