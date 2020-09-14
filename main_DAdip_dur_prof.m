
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

	check = 0;
	[model, species, params, Toffset] = msn_setup(check);

%%{	
	targ = 'D2R';
	reserv = species{targ,'Obj'}.InitialAmount;
	species{targ,'Obj'}.InitialAmount = reserv * 2;
%%}

%%{	
	targ = 'RGS';
	reserv = species{targ,'Obj'}.InitialAmount;
	species{targ,'Obj'}.InitialAmount = reserv * 2;
%%}

%%%

	durDA = 0.01*2.^[0:7];
	NUMd  = numel(durDA);
	cols = ones(1,3).*[(NUMd-1:-1:0)/NUMd]';
	for i = 1:numel(durDA); durDA_leg{i} = sprintf('%g s', durDA(i)); end

	fig     = figure;
	trange  = [-1,3];
	yranges  = {[-0.1, 0.8], [-0.04,0.25], [-1,10]};
	ylegends = {'(uM)', '(uM)', '(uM)'};
	a = {};
	for i = 1:numel(ylegends);
		a{i} = plot_prep(fig, trange, yranges{i}, 'Time (s)', ylegends{i}, i);
		plot(a{i}, trange, [0 0], 'k:');
	end
	yticks(a{1},[0 0.5]);
%%%
	
	leg = zeros(NUMd,1);
	for j = 1:NUMd
		% durDA
		model.Parameters(14).Value = durDA(j);
		sd   = sbiosimulate(model);
		% ACtot = obtain_conc('AC1'   , sd, 0);
		% Gitot = obtain_conc('Gi_Gbc', sd, 0);
		T    = {};
		DATA = {};
		[T{1}, DATA{1}] = obtain_profile('DA', sd, Toffset);
		[T{2}, DATA{2}] = obtain_profile('Gi_unbound_AC', sd, Toffset);
		[T{3}, DATA{3}] = obtain_profile('Gi_GTP', sd, Toffset);
		for i = 1:numel(T);
			leg(j,:) = plot(a{i}, T{i}, DATA{i}, '-', 'LineWidth', 1.5, 'Color', cols(j,:));
		end
	end
	legend(leg, durDA_leg);
%%

%%%
%%%


function plot_t(a, xx,  t_sim, yrange, reserv)

		id = find(t_sim < 0.5);
		if isempty(id) == 0
			rectangle(a,'Position',[log10(min(xx(id))),yrange(1), ...
				log10(max(xx(id)))-log10(min(xx(id))), yrange(2)-yrange(1)], ...
				'EdgeColor','none','FaceColor',[1,0.8,0.8] )
		end
		plot(a, [log10(reserv), log10(reserv)], yrange, 'k:');

end


function plot_i(a, xx,  i_sim, yrange, reserv)

		id = find(i_sim > 0.75);
		if  isempty(id) == 0
			rectangle(a,'Position',[log10(min(xx(id))), yrange(1), ...
				log10(max(xx(id)))-log10(min(xx(id))), yrange(2)-yrange(1)], ...
				'EdgeColor','none','FaceColor',[0.8,0.8,1] )
		end
		plot(a, [log10(reserv), log10(reserv)], yrange, 'k:');

end


function ax = plot_prep(fig, xx, zz , xtitle, ztitle, i)
	row = i - 1;
	% [(0.15+col*0.4), (0.15+row*0.3)]
	ax = axes(fig, 'Position',[0.1, (0.8-row*0.3),  0.15*1.5,  0.15]);
	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ztitle );
	xlim(xx);
	ylim(zz);
end

