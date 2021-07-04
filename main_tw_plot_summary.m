%%
%%
%%

clear;
addpath('./funcs');
addpath('./funcs2');
init_font;


targ_dirs   = {'data/tw_healthy_adult', 'data/tw_healthy_infant', 'data/tw_schizophrenia', 'data/tw_dystonia'};
tick_labels = {'Adult', 'Infant', 'Schizophrenia', 'Dystonia'};
targ_cols = {  [1 1 1]*0, [0 1 0]*0.7, [0 0 1]*0.7, [1 0 0]*0.7  };

targ_conc = 'ActiveAC';
xminmax   = [0.5, 4.5];


fig = figure();
ax  = plot_prep(fig, xminmax, [-20, 180], '(% Basal)', 0);
xticks([1:numel(targ_dirs)]);
yticks([0,60,120,180]);
xticklabels(tick_labels);
xtickangle(ax,60);


for i = 1:numel(targ_dirs);
	load(sprintf('%s/maxconc_noDAdip_%s.mat', targ_dirs{i}, targ_conc)); % 'maxconc_noDAdip'
	load(sprintf('%s/maxconcs_%s.mat', targ_dirs{i}, targ_conc)); % maxconcs

	ref = bar(ax, i, 100 * (max(maxconcs) - maxconc_noDAdip) ./maxconc_noDAdip, 0.5 );
	ref.FaceColor = targ_cols{i};
	ref.EdgeColor = 'None';
end



%%
%% function
%%

function ax = plot_prep(fig, xx, yy,  ytitle, ii)
	col = floor(ii / 3);
	row = mod(ii, 3);
	ax = axes(fig, 'Position',[(0.38+col*0.3), 0.7-0.3*row,  0.225,  0.2]); %%

	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	hold on;
	ylabel( ytitle );
	xlim(xx);
	ylim(yy);
end

