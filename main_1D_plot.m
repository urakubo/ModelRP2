
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

%%{
	targs = {'Gi_Gbc'};
	mult_concs = 10.^[-2:0.1:2];
	width = 1.15;
%%}

	fig = figure;
	for i = 1:numel(targs);

		targ = targs{i};
		fprintf('Target: %s \n', targ);

		%% Sim
		[i_sim, idip_sim, t_sim] =  sim_1D( targ, mult_concs, species, model, Toffset);

		%% Theory
		[D2Rtot, RGStot, ACtot] = obtain_init_concs_1D( species, targ, mult_concs );
		[ i_th, idip_th, t_th ] = theory(D2Rtot, ACtot, RGStot, params);


		%% Plot
		xrange = [min(mult_concs), max(mult_concs)];

		yrange = [0.01,10];
		col = [1,0.8,0.8];
		a2 = prep_plot(fig, xrange, yrange,  targ, '(s)', i, width);

		plot_paint(a2, mult_concs,  (t_sim < 0.5),  yrange, col)
		plot(a2, mult_concs, t_sim, 'k-', 'LineWidth',2);
		plot(a2, mult_concs, t_th , 'r:', 'LineWidth',2);
		plot_decoration(a2, xrange, yrange);
		prep_ylog(a2);
		
		
		yrange = [0,120];
		col    = [0,0,1];
		whi    = [1,1,1];

		a1 = prep_plot(fig, xrange, yrange, targ, '(% Total)', i+4, width);
		plot_paint(a1, mult_concs,  (i_sim > 0.7),  yrange, col*0.2+whi*0.8)
		plot(a1,   mult_concs, i_sim*100, 'k-', 'LineWidth',2);
		plot(a1,   mult_concs, i_th*100, ':', 'LineWidth',2, 'Color', col);
		plot_decoration(a1, xrange, yrange);

		col = [0, 0.5, 1];
		a3 = prep_plot(fig, xrange, yrange, targ, '(% Total)', i+8, width);

		plot_paint(a3, mult_concs,  (idip_sim < 0.30),  yrange, col*0.2+whi*0.8)
		plot(a3,   mult_concs, idip_sim*100, 'k-', 'LineWidth',2);
		plot(a3,   mult_concs, idip_th*100, ':', 'LineWidth',2, 'Color', col);

	%{
		plot_paint(a3, mult_concs,  ((i_sim + idip_sim)./2 > 0.5),  yrange, col*0.2+whi*0.8)
		plot(a3,   mult_concs, (i_sim + idip_sim)./2*100, 'k-', 'LineWidth',2);
		plot(a3,   mult_concs, (i_th + idip_th)./2*100, ':', 'LineWidth',2, 'Color', col);
	%}

		plot_decoration(a3, xrange, yrange)

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


function ax = prep_plot(fig, xx, zz , xtitle, ztitle, i, width)
	ii = i - 1;
	row = floor(ii / 4);
	col = mod(ii, 4);
	ax = axes(fig, 'Position',[(0.1+col*0.225), (0.7-row*0.3),  1.15 * 0.13 * width,  0.18]); %%

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


function [iD2R, iRGS, iAC1] = obtain_init_concs_1D( species, targ, mult_concs )

	iD2R = ones(size(mult_concs)) *  species{'D2R','Obj'}.InitialAmount;
	iRGS = ones(size(mult_concs)) *  species{'RGS','Obj'}.InitialAmount;
	iAC1 = ones(size(mult_concs)) *  species{'AC1','Obj'}.InitialAmount;
	% fprintf('obtain_init_concs, %s \n',  targ);
	% fprintf('iD2R, iRGS, iAC1: %g, %g, %g \n', iD2R(1,1), iRGS(1,1), iAC1(1,1));
	switch targ
		case 'D2R'
			iD2R = mult_concs .* iD2R;
		case 'RGS'
			iRGS = mult_concs .* iRGS;
		case 'AC1'
			iAC1 = mult_concs .* iAC1;
		otherwise
			fprintf("Error: %s\n", targ);
	end;

end

function plot_decoration(ax, xrange, yrange)
	plot(ax, [1 1], yrange, 'k:', 'LineWidth', 0.5);
	plot(ax, xrange, [yrange(1) yrange(1)], 'k-');
	plot(ax, [xrange(1) xrange(1)], yrange, 'k-');
end

function prep_ylog(ax)
	set(ax, 'YScale', 'log');
	set(ax, 'YTick', 10.^(-2:1));
	set(ax, 'YTickLabel',  num2str( get(gca,'YTick')' ,'%g'));
end


