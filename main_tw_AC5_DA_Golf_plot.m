%%
%% Init
%%

clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;


id_state  = 4;

i_timing  = 15;
% DA_delay  = -3:0.25:4;

targ_dirs    = {'data/tw_healthy_adult_' , ...
				'data/tw_healthy_infant_', ...
				'data/tw_schizophrenia_' , ...
				'data/tw_dystonia_'};
dec_inc      = {'decDA_incGolf', 'incDA_incGolf'};
mult_dec_inc  = [1, 0.5];

targ_cols  = {  [1 1 1]*0, [0 1 0]*0.7, [0 0 1]*0.7, [1 0 0]*0.7  };
targ_concs = {'Golf',     'DA',    'ActiveAC'};

targ_maxmin = {[0,1], [0,2.4], [0,50]};
targ_yticks = {[0,1]  , [0,1,2]  , [0,25,50]};

xminmax = [-4,4];

%%
%% Load
%%

load(sprintf('%s%s/DA_delay.mat'  , targ_dirs{id_state}, dec_inc{1}) ); % 'DA_delay'

%%
%%
%%
fig = figure();
ax = {};
for i = 1:numel(targ_concs);

	% Prep
	ax{i} = plot_prep_(fig, xminmax, targ_maxmin{i}, 'Time (s)', targ_concs{i}, i);
	yticks(ax{i},targ_yticks{i});
	plot(ax{i}, [0 0], targ_maxmin{i}, 'k:', 'LineWidth', 0.5);
	plot(ax{i}, [1 1], targ_maxmin{i}, 'k:', 'LineWidth', 0.5);
	
	switch targ_concs{i}
		case 'ActiveAC'
			plot(ax{i}, [0, 1.6]+DA_delay(i_timing), [1, 1] .* targ_maxmin{i}(2).* 0.94, 'r-', 'LineWidth', 2);
			plot(ax{i}, [0, 1], [1, 1] .* targ_maxmin{i}(2) .* 0.98, 'b-', 'LineWidth', 2);
		case 'DA'
			plot(ax{i}, [DA_delay(i_timing), DA_delay(i_timing)+1.6], [1, 1]*2.2, 'r-', 'LineWidth', 2);
		case 'Golf'
			plot(ax{i}, [0, 1], [1, 1]*0.9, 'b-', 'LineWidth', 2);
	end


	% Plot
	for id_dec_inc = numel(dec_inc):-1:1;
		load(sprintf('%s%s/time_courses_%s.mat', targ_dirs{id_state}, dec_inc{id_dec_inc}, targ_concs{i}));

		switch targ_concs{i}
			case 'ActiveAC'
				col = mult_dec_inc(id_dec_inc) .* targ_cols{id_state}+( 1-mult_dec_inc(id_dec_inc) ) .* [1,1,1];
				plot(ax{i}, time_courses{i_timing}(:,1), 100.*time_courses{i_timing}(:,2), ...
					'-', 'LineWidth', 3-id_dec_inc, 'Color', col );
				plot(ax{i}, xminmax, [1 1]*100, 'k:' );
			case 'DA'
				col = ( 1-mult_dec_inc(id_dec_inc) ) .* [1,1,1];
				plot(ax{i}, time_courses{i_timing}(:,1), time_courses{i_timing}(:,2), ...
					'-', 'LineWidth', 3-id_dec_inc, 'Color', col );
			case 'Golf'
				col = ( 1-mult_dec_inc(id_dec_inc) ) .* [1,1,1];
				plot(ax{i}, time_courses{i_timing}(:,1), time_courses{i_timing}(:,2), ...
					'-', 'LineWidth', 3-id_dec_inc, 'Color', col );
		end
	end

end

%%
%% Time window
%%

yminmax = targ_maxmin{3};
ytick   = targ_yticks{3};

targ_conc = 'ActiveAC';
id_t = find(DA_delay >= -3.1);
ax = plot_prep(fig, xminmax, yminmax, 'DA-dip/burst delay (s)', '(%)', 7);
yticks(ax, ytick);
plot(ax, [0 0], yminmax, 'k:', 'LineWidth', 0.5);
plot(ax, [1 1], yminmax, 'k:', 'LineWidth', 0.5);

plot(ax, [0, 1], [1, 1] .* yminmax(2) .* 0.95, 'b-', 'LineWidth', 2);


for id_dec_inc = numel(dec_inc):-1:1;

	col = mult_dec_inc(id_dec_inc) .* targ_cols{id_state}+( 1-mult_dec_inc(id_dec_inc) ) .* [1,1,1];
	load(sprintf('%s%s/maxconcs_%s.mat'          , targ_dirs{id_state}, dec_inc{id_dec_inc}, targ_conc )); %
	load(sprintf('%s%s/maxconc_noDAdip_%s.mat'   , targ_dirs{id_state}, dec_inc{id_dec_inc}, targ_conc )); % 'maxconc_noDAdip'
	load(sprintf('%s%s/maxconc_constGolf_%s.mat' , targ_dirs{id_state}, dec_inc{id_dec_inc}, targ_conc )); % 'maxconc_noCa'

	switch dec_inc{id_dec_inc}
		case 'decDA_incGolf'
			plot(ax, DA_delay(id_t), 100 * maxconcs(id_t), '-', 'LineWidth', 2, 'Color', col );
			a = plot(-3.5, 100 * maxconc_constGolf , 'o', 'Color',  col, 'MarkerFaceColor', 'w');
			b = plot(-3.5, 100 * maxconc_noDAdip , 'o', 'Color', col, 'MarkerFaceColor', targ_cols{id_state});
		case 'incDA_incGolf'
			plot(ax, DA_delay(id_t), 100 * maxconcs(id_t), '-', 'LineWidth', 1, 'Color', col );
			c = plot(-3.5, 100 * maxconc_constGolf , 'o', 'Color',  col, 'MarkerFaceColor', 'w');
	end
end

title(ax,targ_dirs{id_state},'interpreter','none');

%{
legend(ax,[a,c,b],{'DA dip only', 'DA burst only','Golf only'});
legend(ax,'boxoff');
legend(ax, 'Location','best');
%}


%%
%%
%%
function ax = plot_prep_(fig, xx, yy,  xtitle, ytitle, i)
	if i <= 5
		ax = axes(fig, 'Position',[(0.08+0*0.3), (0.80 - (i-1)*0.18),  0.15*1.5,  0.25/2.5]); %%
	else
		ii = i -6;
		col = floor(ii / 3);
		row = mod(ii, 3);
		ax = axes(fig, 'Position',[(0.08+(col+1)*0.3), 0.1+0.6-0.3*row,  0.15*1.5,  0.2]); %%
	end

	ax.ActivePositionProperty = 'Position';
%	title(titl,'interpreter','none');
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ytitle );
	xlim(xx);
	ylim(yy);
end


%%
%%
%%
function ax = plot_prep(fig, xx, yy,  xtitle, ytitle, i)
	if i <= 5
		ax = axes(fig, 'Position',[(0.08+0*0.3), (0.60 - (i-1)*0.25),  0.1*1.5,  0.35/2.5]); %%
	else
		ii = i -6;
		col = floor(ii / 3);
		row = mod(ii, 3);
		ax = axes(fig, 'Position',[(0.08+(col+1)*0.3), 0.1+0.6-0.3*row,  0.15*1.5,  0.2]); %%
	end

	ax.ActivePositionProperty = 'Position';
%	title(titl,'interpreter','none');
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ytitle );
	xlim(xx);
	ylim(yy);
end


