	%%
	%%
	%%
	%%

	clear;
	addpath('./funcs');
	addpath('./models');
	data_dir ='data/Timing/';
	img_dir ='imgs/';
	Toffset_VGCC = 1910;
	%%
	%% Attribute
	%%

	TYPE = 'D2'; DAbasal = 0.5; kb_DA_D1R = 300; STIM = 'Dip';
%	TYPE = 'D1'; DAbasal = 0.0; kb_DA_D1R = 120; STIM = 'Burst';
%	TYPE = 'D1_Pav'; DAbasal = 0.0; kb_DA_D1R = 120; STIM = 'Burst';

	SVR  = 30  ; % r = 0.1; % Spine

	%

	%% Timing - DA_delay
	load(sprintf('%sDA_Concs_%s_%g_%g.mat',data_dir, TYPE, SVR, DAbasal)); % DA_Concs
	filename = sprintf('%sDA_delay_%s_%g_%g_%s_TimingTimeCourse.mat',data_dir, TYPE, SVR, DAbasal, STIM)
	load(filename);

	%% 	'Ca';
	TNAME = 'Ca';
	filename = sprintf('%s%s_D2_30_0.5_Dip_TimingTimeCourse.mat',data_dir,TNAME)
	load(filename);
	Ca = data{1};

	%% 	'DA';
	TNAME = 'DA';
	filename = sprintf('%s%s_D2_30_0.5_Dip_TimingTimeCourse.mat',data_dir,TNAME)
	load(filename);
	DA = data{24};

	%% Dip1 data load; PKA peaks - concs
	TNAME = 'Ct';
	filename = sprintf('%s%s_%s_%g_%g_%s_Timing.mat',data_dir,TYPE, TNAME, SVR, DAbasal, STIM)
	load(filename);
	Ct_dip = concs;
	Ct_alone = concs(1);

	id = find(DA_delay > -3.2);
	DA_delay = DA_delay(id);
	Ct_dip   = Ct_dip(id);

	%% Dip2 data load; PKA peaks - concs
	STIM = 'Dip2';
	filename = sprintf('%s%s_%s_%g_%g_%s_Timing.mat',data_dir,TYPE, TNAME, SVR, DAbasal, STIM)
	load(filename);
	Ct_dip2 = concs;
	Ct_dip2 = Ct_dip2(id);


	%%
	%% Figure
	%%
	fig = figure('pos',[200 200 300 400],'PaperUnits','inches','PaperPosition',[2 2 3 4]);
	fig_init(fig);

	%%
	%% Plot Ca2+
	%%
	xminmax = [-1.5, 3.5];
	yminmax = [0, 1.5];
	id = 1;
	plot_concs_init0( xminmax, yminmax, id )
	yticks([0,1]);
	plot( Ca(:,1), Ca(:,2), 'k-', 'LineWidth', 1);

	%%
	%% Plot DA
	%%
	xminmax = [-1.5, 3.5];
	yminmax = [0, 0.7];
	id = 2;
	plot_concs_init0( xminmax, yminmax, id );
	yticks([0,0.5]);
	plot( DA(:,1), DA(:,2), 'r-', 'LineWidth', 1);

	%%
	%% Plot Timw Window
	%%


	xminmax = [-5,5];
	yminmax = [0,0.45];
	plot_concs_init( TNAME, xminmax );
	
	plot([0 0], yminmax, 'k:');
	plot(-4, Ct_alone, 'ko', 'MarkerFaceColor', 'k');

	id1 = plot( DA_delay, Ct_dip , '-', 'LineWidth', 2, 'Color', 'k');
	id2 = plot( DA_delay, Ct_dip2, '--', 'LineWidth', 1, 'Color', 'k');
	leg = legend([id1, id2],{'DA dip','DA increase'});
    set(leg,'Location','northwest');
	legend boxoff;

	%%%
	%%%

function ax1 = plot_concs_init0( xminmax, yminmax, id )

	if id == 1;
		ax1 = axes('Position',[0.2 0.8 0.6 0.1]);
	else
		ax1 = axes('Position',[0.2 0.6 0.6 0.1]);
	end
	ax1.ActivePositionProperty = 'Position';
	xlabel('Time (s)');
	xlim(xminmax);
	ylim(yminmax);
	xticks([-10:10]);
	box off;
	set(gca,'TickDir','out');
	hold on;

end


function ax1 = plot_concs_init( tname, xminmax )
	ax1 = axes('Position',[0.2 0.1 0.6 0.3]);
	ax1.ActivePositionProperty = 'Position';
	ylabel(tname);
	xlabel('DA delay (s)');
	xlim(xminmax);
	xticks([floor(min(xminmax)):ceil(max(xminmax))]);
	yticks([0:0.2:1]);
	box off;
	set(gca,'TickDir','out');
	hold on;
end



function fig_init(fig);
	fontName = 'Arial';
	set(fig,'defaultAxesXColor','k'); %%% factory is [0.15,0.15,0.15]
	set(fig,'defaultAxesYColor','k');
	set(fig,'defaultAxesZColor','k');
	set(fig,'defaultAxesTickDir','out');
	set(fig,'defaultAxesBox','off');
	set(fig,'defaultAxesFontName',fontName);
	set(fig,'defaultTextFontName',fontName);
	set(fig,'defaultLegendFontName',fontName);
end

