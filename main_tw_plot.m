%%
%% Init
%%

clear;
addpath('./model');
addpath('./model_TimeWindow');
addpath('./funcs');
addpath('./funcs2');
init_font;


id_state = 4;
i_timing = 15;


targ_dirs   = {'data/tw_healthy_adult', 'data/tw_healthy_infant', 'data/tw_schizophrenia', 'data/tw_dystonia'};
targ_cols = {  [1 1 1]*0, [0 1 0]*0.7, [0 0 1]*0.7, [1 0 0]*0.7  };
targ_concs  = {'Golf',     'DA',    'Ca',    'ActiveAC'};
targ_maxmin = {[0,1.2], [0,1.2],   [0,2],	[0,20]};
targ_yticks = {[0,1], [0,1],   [0,1,2],	[0,10,20]};

%%
%% Load simulation data
%%

load(sprintf('%s/DA_delay.mat'  , targ_dirs{id_state})); % 'DA_delay'
gray = [1,1,1]*0.6;

% AC1
species     = InitSpecies();
InitAC = species{'AC1','Conc'};

%%
%% Figure
%%

fig = figure();
xminmax = [-3,3];
ax = {};
for i = 1:numel(targ_concs);
	load(sprintf('%s/time_courses_%s.mat'   , targ_dirs{id_state}, targ_concs{i})); % time_courses
	ax{i} = plot_prep(fig, xminmax, targ_maxmin{i}, 'Time (s)', targ_concs{i}, i);
	yticks(ax{i},targ_yticks{i});

	if strcmp(targ_concs{i}, 'ActiveAC')
		time_courses{i_timing}(:,2) = 100./InitAC.*time_courses{i_timing}(:,2);
		time_courses{end}(:,2) = 100./InitAC.*time_courses{end}(:,2);
	end

	plot(ax{i}, time_courses{i_timing}(:,1), time_courses{i_timing}(:,2), '-', 'LineWidth', 1, 'Color', 'k');
	plot(ax{i}, [0 0], targ_maxmin{i}, 'k:', 'LineWidth', 0.5);
end

title(ax{1}, targ_dirs{id_state},'interpreter','none');


%% Tick DA
t_optoDA = DA_delay(i_timing): -0.2: DA_delay(1)+xminmax(1);
t_optoDA = [t_optoDA, DA_delay(i_timing)+0.5:0.2:xminmax(2)];
i = 2;
yy = [targ_maxmin{i}(2), targ_maxmin{i}(2)*0.9+ targ_maxmin{i}(1)*0.1];
for j = 1:numel(t_optoDA);
	plot(ax{i}, [1, 1] * t_optoDA(j), yy, '-', 'LineWidth', 0.5, 'Color', 'r');
end

%% Tick Ca
i = 3;
yy = [targ_maxmin{i}(2), targ_maxmin{i}(2)*0.9+ targ_maxmin{i}(1)*0.1];
for j = 0:9
	plot(ax{i}, [j/10, j/10], yy, '-', 'LineWidth', 0.5, 'Color', 'b');
end



%%
%% Time windows
%%

i = 4;
targ_concs  = {'Golf',     'DA',    'Ca',    'ActiveAC'};

load(sprintf('%s/maxconcs_%s.mat', targ_dirs{id_state}, targ_concs{i} )); %
load(sprintf('%s/maxconc_noDAdip_%s.mat', targ_dirs{id_state}, targ_concs{i})); % 'maxconc_noDAdip'
load(sprintf('%s/maxconc_noCa_%s.mat'   , targ_dirs{id_state}, targ_concs{i})); % 'maxconc_noCa'

id_t          = find(DA_delay >= -2.1);
normal_factor = 100./InitAC;
targ_maxmin   = [0, 33];

ax = plot_prep(fig, xminmax, targ_maxmin, 'DA-dip delay (s)', '(%)', 6);
plot(ax, DA_delay(id_t), normal_factor * maxconcs(id_t), '-', 'LineWidth', 2, 'Color', targ_cols{id_state} );
plot(ax, -2.5, normal_factor * maxconc_noCa    , 'o', 'Color',  targ_cols{id_state}, 'MarkerFaceColor', 'w');
plot(ax, -2.5, normal_factor * maxconc_noDAdip , 'o', 'Color', targ_cols{id_state}, 'MarkerFaceColor', targ_cols{id_state});
plot(ax, [0 0], targ_maxmin, 'k:', 'LineWidth', 0.5);


%%
%%
%%
function ax = plot_prep(fig, xx, yy,  xtitle, ytitle, i)
	if i <= 5
		ax = axes(fig, 'Position',[(0.08+0*0.3), (0.80 - (i-1)*0.18),  0.15*1.5,  0.2/2.5]); %%
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


