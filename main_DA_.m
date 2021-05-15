%%
%% Init
%%
clear;
addpath('./model');
addpath('./funcs');
addpath('./funcs2');
init_font;


%%
%% Model definition
%%
stop_time               = 4;
Toffset_DA              = 2;
flag_competitive        = 0;
flag_Gi_sequestrated_AC = 1;

init_species = InitSpecies();
init_params  = InitParams()
[model, species, params] = DefineModel(init_species, init_params, stop_time);
InitReacs(model, species, params, flag_competitive, flag_Gi_sequestrated_AC);


%%
%% Simulation config
%%
configsetObj = getconfigset(model);
set(configsetObj.SolverOptions, 'AbsoluteTolerance', 1.000000e-08);
set(configsetObj.SolverOptions, 'RelativeTolerance', 1.000000e-05);


%%
%% Add event
%%
T_DA  = addparameter(model, 'Toffset_DA'  , Toffset_DA);
ReacEnz('DA', 'DAT', 'None', 'Km_DAT', 'kcat_DAT', model);
addevent(model, 'time>=Toffset_DA' , 'DA = DA + DA_opto' );

id_Km_DAT   = find(string({model.Parameters.Name}) == "Km_DAT");
id_kcat_DAT = find(string({model.Parameters.Name}) == "kcat_DAT");
id_DA_opto  = find(string({model.Parameters.Name}) == "DA_opto");
Km_DAT   = model.Parameters(id_Km_DAT);
kcat_DAT = model.Parameters(id_kcat_DAT);
DA_opto  = model.Parameters(id_DA_opto);


fprintf('\nModel generated\n\n');

DA_opto.Value = 1;
kcat_DAT.Value = 6.4;

DA_opto.Value = 0.8572;
kcat_DAT.Value = 5.7;

DA_opto.Value = 0.7744;
kcat_DAT.Value = 5.3;

DA_opto.Value = 0.7251;
kcat_DAT.Value = 5.0;

DA_opto.Value = 0.6877;
kcat_DAT.Value = 4.8;

DA_opto.Value = 0.6622;
kcat_DAT.Value = 4.7;

DA_opto.Value = 0.6494;
kcat_DAT.Value = 4.6;

DA_opto.Value = 0.6365;
kcat_DAT.Value = 4.6;

%%
%% Simulation
%%
sd = sbiosimulate(model);

targ = 'DA';
[T, DATA] = obtain_profile(targ, sd, Toffset_DA);


%%
%% Plot graph
%%
yrange  = [-0.2, 1]*max(DATA)*1.2;
trange  = [-1,stop_time-Toffset_DA];

id_t = find(  ( T >=  trange(1) ) .* ( T < trange(2)  )  );
T    = T(id_t);
DATA = DATA(id_t);
width = fwhm(T,DATA);

linew     = 2;
col       = [1 1 1]*0;
panel     = 1;
ylegend   = '(uM)';


%%
%%
%%
fig   = figure;
title_ = sprintf('%s; kcat_DAT: %g s; FWHM: %g s', targ, kcat_DAT.Value, width);
a = plot_prep(fig, trange, yrange, title_, 'Time (s)', ylegend);
hold on;
plot(a, trange, [0 0], 'k:');
plot(a, [0, width], [1 1]*max(DATA)/2, 'r-');
plot(a, T, DATA, '-', 'LineWidth', linew, 'Color', col);

% plot(a, [0 0], [yrange(2), yrange(2)*0.8 - yrange(1)*0.2],'r-','LineWidth',1);

% yticks(a,[0 0.5]);


%tt = trange(1):0.1:trange(2);
%tt = 0:0.01:1;
%plot(tt, -kcat_DAT*tt + 1.0, '-', 'LineWidth', linew, 'Color', 'r');


function ax = plot_prep(fig, xx, zz ,titl, xtitle, ytitle)

	ax =subplot(1,1,1);
	title(titl,'interpreter','none');
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ytitle );
	xlim(xx);
	ylim(zz);
end


