%%
%% Init
%%

clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;

i_dir  = 4;
targ_dirs = {'data/tw_healthy_adult', 'data/tw_healthy_infant', 'data/tw_schizophrenia', 'data/tw_dystonia'};
targ_cols = {  [1 1 1]*0.5, [0 1 0], [0 0 1], [1 0 0]  };

i_conc = 1;
targ_concs = { 'Ct',	'cAMP' };

%%
%%
%%

%%
%% Figure
%%
fig = figure('pos',[200 200 300 400],'PaperUnits','inches','PaperPosition',[2 2 3 4]);

xminmax = [-5, 5];
% yminmax = [ 0, 1.5];
yminmax = [ -0.5, 2.5];

a1 = plot_concs_init( targ_concs{i_conc}, xminmax, yminmax );
plot([0 0], yminmax, 'k:');

for i_dir = 1:numel(targ_dirs);

	load(sprintf('%s/DA_delay.mat'          ,targ_dirs{i_dir})); % 'DA_delay'
	load(sprintf('%s/maxconcs_%s.mat'       , targ_dirs{i_dir}, targ_concs{i_conc})); % 'maxconcs'
	load(sprintf('%s/maxconc_noDAdip_%s.mat', targ_dirs{i_dir}, targ_concs{i_conc})); % 'maxconc_noDAdip'
	load(sprintf('%s/maxconc_noCa_%s.mat'   , targ_dirs{i_dir}, targ_concs{i_conc})); % 'maxconc_noCa'
	% id1 = plot( DA_delay, maxconcs ./ maxconc_noDAdip - 1, '-', 'LineWidth', 2, 'Color', targ_cols{i_dir} );
	% id1 = plot( DA_delay, (maxconcs - maxconc_noDAdip) ./ (maxconc_noDAdip+0.01), '-', 'LineWidth', 2, 'Color', targ_cols{i_dir} );
	id1 = plot( DA_delay, maxconcs, '-', 'LineWidth', 2, 'Color', targ_cols{i_dir} );
	plot(-4, maxconc_noCa , 'o', 'Color', targ_cols{i_dir} , 'MarkerFaceColor', targ_cols{i_dir});
	plot(-4, maxconc_noDAdip, 'o', 'Color', targ_cols{i_dir} , 'MarkerFaceColor', [1,1,1]);

end


% id2 = plot( DA_delay, Ct_dip2, '--', 'LineWidth', 1, 'Color', 'k');
% leg = legend([id1, id2],{'DA dip','DA increase'});
% set(leg,'Location','northwest');
% legend boxoff;


%%
%%
%%

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


function ax1 = plot_concs_init( tname, xminmax, yminmax )
	ax1 = axes('Position',[0.2 0.1 0.6 0.3]);
	ax1.ActivePositionProperty = 'Position';
	xlabel('DA delay (s)');
	ylabel(tname);
	xlim(xminmax);
	ylim(yminmax);
	xticks([floor(min(xminmax)):ceil(max(xminmax))]);
	yticks([0:0.5:yminmax(2)]);
	box off;
	set(gca,'TickDir','out');
	hold on;
end


