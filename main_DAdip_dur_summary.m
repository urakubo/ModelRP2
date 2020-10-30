
%
% Init
%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	init_font;

	[model, species, params, Toffset] = msn_setup(0);
	AC1_tot = species{'AC1','Obj'}.InitialAmount;

	targs_change = {{} ,{'D2R','RGS'}, {'D2R','RGS'}, {'D2R','RGS'}};
	targs_change_title = {'Healthy adult', 'Healthy infant', 'Schizophrenia', 'Dystonia'};
	mults = {[], [0.5,0.5], [4, 0.5], [0.5, 2.0]};
	cols = {  [1 1 1]*0.5, [0 1 0], [0 0 1], [1 0 0]  };

	durDA  = 0.00125*2.^[0:0.5:15]
	trange = [0.04, 40];
	trange = [0.01, 40];
	yrange  = [-10,50];

	NUMd  = numel(durDA);
	for i = 1:numel(durDA); durDA_leg{i} = sprintf('%g s', durDA(i)); end
	cols2 = ones(1,3).*[(NUMd-1:-1:0)/NUMd]';

	fig = figure('pos',[200 200 400 400],'PaperUnits','inches','PaperPosition',[2 2 4 4]);
	fig.Renderer='Painters';

	% trange  = [min(durDA),max(durDA)];

	a = plot_prep(fig, trange, yrange, 'Duration (s)', 'ACresponse (%)');
	yticks([0:20:40]);
	plot(a, trange, [0 0], 'k:');
	plot(a, [1 1]*0.5, yrange, 'k:' );


%%%
	for i = 1:numel(targs_change);

		results = zeros( numel(durDA), 1 );
		for j = 1:numel(durDA);
		
			% fprintf('i: %d ,j: %d \n', i, j);
		
			model.Parameters(14).Value = durDA(j);
			sd = run_sbiosimulate(model, species, targs_change{i}, mults{i});

			% [t, Conc]       = obtain_profile('Gi_unbound_AC', sd, Toffset );
			% Gi_unbound_AC_0 = interp1(t, Conc, 0);
			[t,Io_Idip]       = Obtain_Io_Idip(sd, Toffset, AC1_tot);

			results(j,1) = integ(t, Io_Idip, [0, 100]) ./ durDA(j) ;

		end

		[t, Conc]       = obtain_profile('Gi_GTP', sd, Toffset );
		Gi_GTP_0 = interp1(t, Conc, 0);
		fprintf('%s : %g \n', targs_change_title{i}, Gi_GTP_0 )

		plot(a, durDA, (results - results(1,1)) * 100, '-', ...
			'Color', cols{i}, ...
			'MarkerFaceColor', cols{i}, ...
			'MarkerSize', 3, ...
			'LineWidth', 2);

	end
%%

function [t,Io_Idip] = Obtain_Io_Idip(sd, Toffset, AC1tot)
		AC1GTPo    = obtain_conc('AC1_Gi_GTP', sd, Toffset);
		AC1GDPo    = obtain_conc('AC1_Gi_GDP', sd, Toffset);
		[t, AC1GTP]     = obtain_profile( 'AC1_Gi_GTP' , sd, Toffset );
		[t, AC1GDP]     = obtain_profile( 'AC1_Gi_GDP' , sd, Toffset );
		io         =  ( AC1GTPo + AC1GDPo )./AC1tot;
		idip       =  ( AC1GTP + AC1GDP )./AC1tot;
		Io_Idip    =  io - idip;
		
end

%%%
%%%

function result = integ( t, conc, range)
	ids = find( (t < max(range)) &  (t > min(range)) );
	tt    = t(ids);
	tconc = conc(ids);
	
	tt1 = tt;
	tt2 = tt;

	tt1(end) = [];
	tt2(1)   = [];
	tt = tt2 - tt1;
	
	tconc(1) = [];
	
	result = dot(tt, tconc);
	% size(result)
end


function sd = run_sbiosimulate(model, species, targ, mult)
	reservs = {};
	for i = 1: numel(targ)
		reservs{i} = species{targ{i},'Obj'}.InitialAmount;
		species{targ{i},'Obj'}.InitialAmount = reservs{i} * mult(i);
	end
	sd = sbiosimulate(model);
	for i = 1: numel(targ)
		species{targ{i},'Obj'}.InitialAmount = reservs{i};
	end
end


function ax = plot_prep(fig, xx, yy , xtitle, ytitle)

	ax = axes(fig, 'Position',[0.2 0.2 0.4 0.4]);
	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	set(gca, 'XScale', 'log');
	set(ax,'XTick',[0.01,0.1,1,10,100]);
	xlim(xx);
	ylim(yy);
	set(gca, 'XTickLabel',  num2str( get(gca,'XTick')' ,'%-g'));

	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ytitle );

end

