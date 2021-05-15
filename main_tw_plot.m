%%
%% Init
%%

clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;

data_dir ='data/TimeWindow';
mkdir(data_dir);

%%
%%
%%

load(sprintf('%s/DA_delay.mat',data_dir)); % 'DA_delay'

targs = {'Ct',	'cAMP' };
k = 1;
load(sprintf('%s/max_%s.mat', data_dir, targs{k}));          % 'maxconcs'
load(sprintf('%s/max_%s_noDAdip.mat', data_dir, targs{k}) ); % 'maxconc_noDAdip'
load(sprintf('%s/max_%s_noCa.mat', data_dir, targs{k}) );    % 'maxconc_noCa'



%%
%% Figure
%%
fig = figure('pos',[200 200 300 400],'PaperUnits','inches','PaperPosition',[2 2 3 4]);

xminmax = [-5,5];
yminmax = [0,0.45];
plot_concs_init( targs{k}, xminmax );

plot([0 0], yminmax, 'k:');
plot(-4, maxconc_noCa   , 'ko', 'MarkerFaceColor', 'k');
plot(-4, maxconc_noDAdip, 'ko', 'MarkerFaceColor', [1,1,1]*0.5);

id1 = plot( DA_delay, maxconcs, '-', 'LineWidth', 2, 'Color', 'k');
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


