
%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	check = 0;
	[model, species, params, Toffset] = msn_setup(check);
	
	targs = {'D2R','RGS','AC1'};
	mult_concs = 10.^[-1:0.1:1];
	width = 1;

	% targs = {'Gi_Gbc'};
	% mult_concs = 10.^[-2:0.1:2];
	% width = 1.15;

%%%

	fig = figure;
	for i = 1:numel(targs);

		%% Sim
		targ = targs{i};
		fprintf('Target: %s \n', targ);
		[t_sim, i_sim] =  sim_1D( targ, mult_concs, species, model, Toffset);

		%% Theory
		mD2R = ones(size(mult_concs)) *  species{'D2R','Obj'}.InitialAmount;
		mRGS = ones(size(mult_concs)) *  species{'RGS','Obj'}.InitialAmount;
		mAC  = ones(size(mult_concs)) *  species{'AC1','Obj'}.InitialAmount;
		switch targ
			case 'D2R'
				mD2R = mult_concs .* mD2R;
			case 'RGS'
				mRGS = mult_concs .* mRGS;
			case 'AC1'
				mAC = mult_concs .* mAC;
		end;
		[ i_th, t_th ] = theory(mD2R, mAC, mRGS, params);

		%% Plot
		xrange = [min(mult_concs), max(mult_concs)];

		yrange = [0.01,10];
		col = [1,0.8,0.8];
		a2 = plot_prep(fig, xrange, yrange,  targ, '(s)', i, width);
		set(a2, 'YScale', 'log');
		set(a2, 'YTick', 10.^(-2:1));
		set(a2, 'YTickLabel',  num2str( get(gca,'YTick')' ,'%g'));
		plot_paint(a2, mult_concs,  (t_sim < 0.5),  yrange, col)
		plot(a2, mult_concs, t_sim, 'k-', 'LineWidth',2);
		plot(a2, mult_concs, t_th , 'r:', 'LineWidth',2);
		plot(a2, [1 1], yrange, 'k:', 'LineWidth', 0.5);
%
		plot(a2, xrange, [yrange(1) yrange(1)], 'k-');
		plot(a2, [xrange(1) xrange(1)], yrange, 'k-');
%
		yrange = [0,120];
		col = [0.8,0.8,1];

		a1 = plot_prep(fig, xrange, yrange, targ, '(% Total)', i+4, width);
		plot_paint(a1, mult_concs,  (i_sim > 0.75),  yrange, col)
		plot(a1,   mult_concs, i_sim*100, 'k-', 'LineWidth',2);
		plot(a1,   mult_concs, i_th*100, 'b:', 'LineWidth',2);
		plot(a1, [1 1], yrange, 'k:', 'LineWidth', 0.5);
%
		plot(a1, xrange, [yrange(1) yrange(1)], 'k-');
		plot(a1, [xrange(1) xrange(1)], yrange, 'k-');
%
	end

%%%
%%%

function plot_paint(a, xx, paint_area,  yrange, color)

	id = find(paint_area);
	if isempty(id) == 0
		id = rectangle(a,'Position',[(min(xx(id))),yrange(1), ...
			(max(xx(id)))-(min(xx(id))), yrange(2)-yrange(1)], ...
			'EdgeColor','none','FaceColor', color );
		id.Clipping = 'on';
	end
end


function ax = plot_prep(fig, xx, zz , xtitle, ztitle, i, width)
	ii = i - 1;
	row = floor(ii / 4);
	col = mod(ii, 4);
	ax = axes(fig, 'Position',[(0.1+col*0.225), (0.7-row*0.3),  0.13 * width,  0.18]); %%

	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	set(gca, 'XScale', 'log');
	set(ax,'XTick',[0.01,0.1,1,10,100]);
	xlim(xx);
	ylim(zz);
	set(gca, 'XTickLabel',  num2str( get(gca,'XTick')' ,'%-g'));
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ztitle );
	ax.Clipping = 'on';
	ax.ClippingStyle = 'rectangle';
end

