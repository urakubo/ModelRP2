
%%
%% Init
%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	init_font;

yrange  = [-0.12, 1]*0.8;;
trange  = [10,15];

kcat_DAT = 6.4;
amplitude_DA_opto =0.85:0.005:0.9; % 0.8572

kcat_DAT = 5.7;
amplitude_DA_opto =0.75:0.005:0.8;

kcat_DAT = 5.3;
amplitude_DA_opto =0.65:0.005:0.75;

kcat_DAT = 5.0;
amplitude_DA_opto =0.65:0.005:0.75;

kcat_DAT = 4.8;
amplitude_DA_opto =0.65:0.005:0.75;

kcat_DAT = 4.7;
amplitude_DA_opto =0.62:0.005:0.65;

kcat_DAT = 4.6;
amplitude_DA_opto =0.62:0.005:0.65; % 0.6365


linew     = 1;
col       = [1 1 1]*0;

%%
%%

flag_competitive 		= 0;
flag_Gi_sequestrated_AC = 1;
flag_optoDA 			= 1;
flag_duration 			= 0;
stop_time  				= trange(2);
Toffset_DA 				= stop_time;
[model, species, params, container] = ...
	msn_setup( flag_competitive, flag_Gi_sequestrated_AC, flag_optoDA, flag_duration, stop_time, Toffset_DA );

kcat_DAT_ = model.Parameters(find(string({model.Parameters.Name}) == "kcat_DAT"));
kcat_DAT_.Value = kcat_DAT;

DA_opto = container('DA_opto');

Toffset        = 0;

targ_molecule  = 'DA';
Average_DA = [];
for i = 1:numel(amplitude_DA_opto);
	DA_opto.Value = amplitude_DA_opto(i);
	% Toffset = container('Toffset_DA').Value;
	sd = sbiosimulate(model);
	[T, DATA] = obtain_profile(targ_molecule, sd, Toffset);
	id_t = find(  ( T >=  trange(1) ) .* ( T < trange(2)  )  );
	tmp = trapz(T(id_t),DATA(id_t))./(T(id_t(end)) - T(id_t(1)));
	Average_DA = [Average_DA, tmp];
	fprintf( 'DA_opto: %g; Average conc of DA: %g\n', amplitude_DA_opto(i), tmp );
end


ymax = max(DATA(id_t));
yrange  = [0, ymax]*1.2;

%%
%%

ylegend  = '(uM)';
fig      = figure;
title_  = sprintf('kcat_DAT: %g s', kcat_DAT);
a = plot_prep_(fig, trange, yrange, title_, 'Time (s)', ylegend, 1);
hold on;
plot(a, [0 0], [yrange(2), yrange(2)*0.8 - yrange(1)*0.2],'r-','LineWidth',0.5);
yticks(a,[0, 0.5, 1]);
plot(a, T, DATA, '-', 'LineWidth', linew, 'Color', col);

%%
%%
TH = 0.5;
t = get_zero_crossing(amplitude_DA_opto, Average_DA - TH);

ylegend = '<DA> (uM)';
title_  = sprintf('Theshold: %g, DA opto: %.4f uM', TH, t);
xrange  = [min(amplitude_DA_opto), max(amplitude_DA_opto)];

b = plot_prep_(fig, xrange, yrange, title_, 'DA opto (uM)', ylegend, 2);
hold on;
plot(b, amplitude_DA_opto, Average_DA, 'o-', 'LineWidth', linew, 'MarkerSize', 2, 'Color', col);
plot(b, xrange, [TH TH], 'k:');

%%
%%


function t_half = get_zero_crossing(T, DATA)
	tmp     = DATA(:,2:end) .* DATA(:,1:end-1);
	id_half = find(tmp <= 0);
%	fprintf('ID: %g\n',id_half)
	DATA    = abs(DATA);
	t_half  = DATA(id_half+1).*T(id_half)+DATA(id_half).*T(id_half+1);
	t_half  = t_half./(DATA(id_half+1) + DATA(id_half) );
end


function ax = plot_prep_(fig, xx, zz ,titl, xtitle, ytitle, i)
	ax = subplot(1,2,i);
	title(titl,'interpreter','none');
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ytitle );
	xlim(xx);
	ylim(zz);
end


%%
%%

