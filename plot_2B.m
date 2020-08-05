
%%%%
%%%% Init
%%%%
	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	font_init;

	check = 0;
	[model, species, params, Toffset] = msn_setup(check);
	targs = {'D2R','RGS','AC1','Gi_Gbc'};
	concs = 10.^[-1:0.1:1];

%%%
%%%

	fig = figure;
	for i = 1:numel(targs);

		%% Sim
		targ = targs{i};
		fprintf('Target: %s \n', targ);
		[t_sim, i_sim, t_th, i_th] =  sims( targ, species, concs, model, Toffset ,params);


		%% Plot
		reserv = species{ targs,'Obj'}.InitialAmount;
		xrange = [min(concs), max(concs)] * reserv ;
		xx     = concs * reserv ;

		yrange = [0,120];
		a1 = plot_prep(fig, log10(xrange), yrange, targ, 'i', i);
		plot_i(a1, xx,  i_sim, yrange, reserv)
		plot(a1, log10(xx), i_sim*100, 'k-', 'LineWidth',2);
		plot(a1, log10(xx), i_th*100, 'b:', 'LineWidth',2);


		yrange = [-2,1];
		a2 = plot_prep(fig, log10(xrange), yrange,   targ, 'T1/2', i+4);
		plot_t(a2, xx,  t_sim, yrange, reserv)
		plot(a2, log10(xx), log10(t_sim), 'k-', 'LineWidth',2);
		plot(a2, log10(xx), log10(t_th), 'r:', 'LineWidth',2);
		%%
	end

%%%
%%%


function [t_sim, i_sim, t_th, i_th] = sims( targ, species, concs, model, Toffset ,params)

	num_concs = numel( concs );
	t_sim     = zeros( num_concs,1 );
	i_sim     = zeros( num_concs,1 );
	i_th      = zeros( num_concs,1 );

	reserv = species{ targ,'Obj'}.InitialAmount;
	for j = 1:num_concs;

	% Sim
		species{ targ,'Obj'}.InitialAmount = concs(j) * reserv;
		sd   = sbiosimulate(model);

	% Get I and T
		AC1tot = obtain_conc('AC1', sd, 0);
		AC1GTP = obtain_conc('AC1_Gi_GTP', sd, Toffset);
		AC1GDP = obtain_conc('AC1_Gi_GDP', sd, Toffset);
		t_sim(j) =  obtain_half('Gi_unbound_AC', sd, Toffset);
		i_sim(j) =  ( AC1GTP + AC1GDP )./AC1tot;

	% Theory
		i_th(j) = get_i_th(sd, Toffset, params);
		t_th(j) = get_t_th(sd, Toffset, params);

	end
	species{ targ,'Obj'}.InitialAmount = reserv;

end


function i_th = get_i_th(sd, Toffset, params)

	Km_hyd_Gi      = params{'Km_hyd_Gi','Obj'}.Value;
	kcat_hyd_Gi    = params{'kcat_hyd_Gi','Obj'}.Value;
	koff_AC_GiGTP  = params{'koff_AC_GiGTP','Obj'}.Value;
	kon_AC_GiGTP   = params{'kon_AC_GiGTP','Obj'}.Value;

	kcat_exch_Gi   = params{'kcat_exch_Gi','Obj'}.Value;
	Km_exch_Gi     = params{'Km_exch_Gi','Obj'}.Value;
	kon_Gbc_Gi     = params{'kon_Gbc_Gi','Obj'}.Value;
	koff_AC_GiGDP  = params{'koff_AC_GiGDP','Obj'}.Value;

	RGS    = obtain_conc('RGS'       , sd, 0);
	DA_D2R = obtain_conc('DA_D2R'    , sd, Toffset);
	ACtot  = obtain_conc('AC1'       , sd, 0);
	kRGS   = RGS * kcat_hyd_Gi ./ Km_hyd_Gi;
	vD2R   = DA_D2R * kcat_exch_Gi;

	tmp = (1/kRGS + 1/koff_AC_GiGDP);
	a   = 1;
	b   = -( tmp * vD2R / ACtot + 1 + (koff_AC_GiGTP + kRGS)/kon_AC_GiGTP/ACtot  );
	c   = tmp * vD2R / ACtot;
	i_th  = ( -b - sqrt(b*b-4*a*c) )/(2*a);

end


function t_th = get_t_th(sd, Toffset, params)

	Km_hyd_Gi      = params{'Km_hyd_Gi','Obj'}.Value;
	kcat_hyd_Gi    = params{'kcat_hyd_Gi','Obj'}.Value;
	koff_AC_GiGTP  = params{'koff_AC_GiGTP','Obj'}.Value;
	kon_AC_GiGTP   = params{'kon_AC_GiGTP','Obj'}.Value;

	kcat_exch_Gi   = params{'kcat_exch_Gi','Obj'}.Value;
	Km_exch_Gi     = params{'Km_exch_Gi','Obj'}.Value;
	kon_Gbc_Gi     = params{'kon_Gbc_Gi','Obj'}.Value;
	koff_AC_GiGDP  = params{'koff_AC_GiGDP','Obj'}.Value;

	RGS    = obtain_conc('RGS'       , sd, 0);
	DA_D2R = obtain_conc('DA_D2R'    , sd, Toffset);
	ACtot  = obtain_conc('AC1'       , sd, 0);

	kRGS   = RGS * kcat_hyd_Gi ./ Km_hyd_Gi;
	vD2R   = DA_D2R * kcat_exch_Gi;
%%
	Kd_AC_GiGTP = koff_AC_GiGTP/kon_AC_GiGTP;
	GTPo = vD2R/kRGS; % AC_Go + Go
	b  = -(GTPo + Kd_AC_GiGTP + ACtot);
	c  = GTPo * ACtot;
	AC_Go  = 0.5*( -b - sqrt( b * b - 4 * c ) );

	numerator   = AC_Go * (AC_Go - 2* (Kd_AC_GiGTP + ACtot));
	denominator = GTPo*( 4*ACtot - 2*AC_Go );
	t_th = (1./kRGS) * log(-denominator./numerator );

end


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
	ii = i - 1;
	row = floor(ii / 4);
	col = mod(ii, 4);
	% [(0.15+col*0.4), (0.15+row*0.3)]
	ax = axes(fig, 'Position',[(0.1+col*0.225), (0.8-row*0.3),  0.15,  0.15]);
	ax.ActivePositionProperty = 'Position';
	box off;
	set(ax,'TickDir','out');
	hold on;
	xlabel( xtitle, 'Interpreter', 'none');
	ylabel( ztitle );
	xlim(xx);
	ylim(zz);
end

