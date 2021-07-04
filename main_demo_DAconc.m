
%%%%
%%%% Init
%%%%


	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;


%%%
	trange  = [-1.0,1.0];

	fig     = figure;

%%
%% Basal
%%
	DAo = 2.^[-2:2] * 0.5;
	Icol = (1:numel(DAo))/max(numel(DAo));
	yrange1 = [-0.2, 2.2];
	yrange2 = [0.02, 5.0];

	a1 = plot_prep(fig, trange, yrange1, 'Time (s)', '(uM)', 5);
	yticks(a1, [0, 0.125, 0.25, 0.5, 1 2])
	plot(a1, trange, [0 0]      , 'k:');

	a2 = plot_prep(fig, trange, [0.05/1.5 2*1.5], 'Time (s)', '(uM)', 6);
	yticks(a2, [0.05, 0.125, 0.25, 0.5, 1, 2])
	set(a2, 'YScale', 'log');
	plot(a2, trange, [0.05 0.05]      , 'k:');
	
	for i = numel(DAo):-1:1;
		t  = [-1.5   , 0,     0,    1.5];
		DA = [DAo(i) , DAo(i) 0.05, 0.05];
		% plot(a1, t, DA, 'k-', 'LineWidth',1,'Color',[0,0,Icol(i)]);
		% plot(a2, t, DA, 'k-', 'LineWidth',1,'Color',[0,0,Icol(i)]);
		plot(a1, t, DA, 'k-', 'LineWidth',1,'Color',[Icol(i),0,0]);
		plot(a2, t, DA, 'k-', 'LineWidth',1,'Color',[Icol(i),0,0]);
	end

%%
%% Dip
%%
	DAdip = 2.^[-2:2] * 0.05;
	Icol = (1:numel(DAdip))/max(numel(DAdip));

	yrange1 = [-0.02, 0.51];
	yrange2 = [0.01, 1.0];

	a1 = plot_prep(fig, trange, yrange1, 'Time (s)', '(uM)', 7);
	yticks(a1, [0.0125, 0.025, 0.05, 0.1, 0.2, 0.5]);
	plot(a1, trange, [0 0] , 'k:');

	a2 = plot_prep(fig, trange, [0.0125/1.5 0.5*1.5], 'Time (s)', '(uM)', 8);
	yticks(a2, [0.0125, 0.025, 0.05, 0.1, 0.2, 0.5]);
	set(a2, 'YScale', 'log');
	
	for i = numel(DAdip):-1:1;
		t  = [-1.5   , 0,     0,    1.5];
		DA = [0.5 , 0.5, DAdip(i), DAdip(i)];
		% plot(a1, t, DA, 'k-', 'LineWidth',1,'Color',[0,Icol(i)/2,Icol(i)]);
		% plot(a2, t, DA, 'k-', 'LineWidth',1,'Color',[0,Icol(i)/2,Icol(i)]);
		plot(a1, t, DA, 'k-', 'LineWidth',1,'Color',[Icol(i), 0, 0]);
		plot(a2, t, DA, 'k-', 'LineWidth',1,'Color',[Icol(i), 0, 0]);
	end

%%
%%
%%

function ax = plot_prep(fig, xx, zz , xtitle, ztitle, i)
	ii = i - 1;
	row = floor(ii / 4);
	col = mod(ii, 4);
	% [(0.15+col*0.4), (0.15+row*0.3)]
	ax = axes(fig, 'Position',[(0.1+col*0.225), (0.8-row*0.3),  0.07,  0.15*2]);
	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ztitle );
	xlim(xx);
	ylim(zz);
end

