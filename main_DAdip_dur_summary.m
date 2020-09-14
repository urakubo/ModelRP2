
%%%%
%%%% Init
%%%%

	rmpath('./model');
	rmpath('./funcs');
	rmpath('./funcs2');
	clear;

	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	
	data_dir = 'data';
	img_dir  = 'imgs';

	[model, species, params, Toffset] = msn_setup(0);
	targs = {{'D2R'}, {'RGS'},{'D2R','RGS'}, {}};
	cols = { [0 0 1], [1 0 0], [0 1 0], [1 1 1]*0.5 };
	mult  = 10;


	durDA = 2.^[-10:5];
	NUMd  = numel(durDA);
	for i = 1:numel(durDA); durDA_leg{i} = sprintf('%g s', durDA(i)); end
	cols2 = ones(1,3).*[(NUMd-1:-1:0)/NUMd]';

	fig = figure('pos',[200 200 400 400],'PaperUnits','inches','PaperPosition',[2 2 4 4]);
	fig.Renderer='Painters';

	% fig     = figure;
	trange  = [-2,1.5];
	yrange  = [-0.04,0.2];
	a = plot_prep(fig, trange, yrange, 'Duration (s)', 'ACfree uM.s/s');
	yticks([0:0.1:0.2]);
	plot(a, trange, [0 0], 'k:');
	plot(a, -0.3010*[1 1], yrange, 'k:' )

%{
	fig2 = figure;
	a2 = axes('Position',[0.1 0.1 0.7 0.7]);
	xlim([-1,12]);
	plot([-1,12], [0,0], 'k--');
	hold on;
%}

%%%
	for i = 1:numel(targs);
		targ = targs{i};
		reservs = change_conc(targ, species, mult);

		results = zeros( numel(durDA), 1 );
		for j = 1:numel(durDA);
		
			% fprintf('i: %d ,j: %d \n', i, j);
		
			model.Parameters(14).Value = durDA(j);
			sd = sbiosimulate(model);

			[t, Conc]       = obtain_profile('Gi_GTP', sd, Toffset );
			Gi_GTP_0 = interp1(t, Conc, 0);
			disp(Gi_GTP_0)
			
			[t, Conc]       = obtain_profile('Gi_unbound_AC', sd, Toffset );
			Gi_unbound_AC_0 = interp1(t, Conc, 0);

			%{
			if (j == 1)
				range = [0, 10];
				ids = find( (t < max(range)) &  (t > min(range)) );
				tt    = t(ids);
				tconc = Conc(ids);
				
				fprintf('%d ,%f \n', i, Gi_unbound_AC_0);
				plot(a2, tt, tconc-Gi_unbound_AC_0, 'o-', 'MarkerSize', 2);
			end
			%}
			
			results(j,1) = integ(t, Conc-Gi_unbound_AC_0, [0, 100]) ./ durDA(j) ;
		end
		restore_conc(targ, species, reservs);

		plot(a, log10(durDA), results - results(1,1), 'o-', ...
			'Color', cols{i}, ...
			'MarkerFaceColor', cols{i}, ...
			'MarkerSize', 3, ...
			'LineWidth', 1.5);

	end
%%

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

function reservs = change_conc(targ, species, mult)
	reservs = {};
	for i = 1: numel(targ)
		reservs{i} = species{targ{i},'Obj'}.InitialAmount;
		species{targ{i},'Obj'}.InitialAmount = reservs{i} * mult;
	end
end

function restore_conc(targ, species, reservs)
	for i = 1: numel(targ)
		species{targ{i},'Obj'}.InitialAmount = reservs{i};
	end
end


function ax = plot_prep(fig, xx, zz , xtitle, ztitle)
	

	ax = axes(fig, 'Position',[0.2 0.2 0.4 0.4]);
	
	% ax = axes(fig, 'Position',[0.1, (0.6),  0.15*1.5,  0.3]);
	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ztitle );
	xlim(xx);
	ylim(zz);
end
