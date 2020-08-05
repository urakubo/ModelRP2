%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	font_init;

	grey = [1,1,1]*0.5;

	check = 0;
	[model, species, params, Toffset] = msn_setup(check);
	% check == 0: normal; 
	% check != 1 AC1 binding do not affect Gi conc.

%%%
%%%
	fprintf('\n');
	targs = {'D2R','AC1','RGS'};

%	tmp = 10.^[-1:0.025:1];
	tmp = 10.^[-1:0.1:2];
	concs{1} 		= tmp;
	concs{2} 		= tmp;
	concs{3} 		= tmp;


	for i = 1:3;
		default_conc{i} = species{targs{i},'Obj'}.InitialAmount;
		concs{i} 		= concs{i} .* default_conc{i};
		fprintf('Original conc %s: %g uM \n', targs{i}, default_conc{i} );
	end


T1_2 = 0.5;  %
Io   = 0.75; %

Io_graded 		= [0.5, 0.75,  0.90, 0.96, 0.98 ];
Io_graded_col 	= [0.8, 0.8, 1;
					0.7, 0.7, 1;
					0.6, 0.6, 1];

%%
%% 2D plot 
%%

%	dims = { [2,1], [3,1], [3,2] };
	dims = { [3,1] };

	for  i = 1:numel(dims);
		concs2 = concs(dims{i});
		targs2 = targs(dims{i});
		default_conc2 = default_conc(dims{i});

		[sd, i_simulation, t_half_simulation] = sim_2d(concs2, targs2, species, model, Toffset);
		[ i_theory, t_half_theory ] = theory_2d(sd, concs2, targs2, species, model, Toffset, params);

		xlog_concs = log10(concs2{1});
		ylog_concs = log10(concs2{2});

		[fig1, ax1] = fig_prep2(targs2, concs2, 'i Theory');
		[fig2, ax2] = fig_prep2(targs2, concs2, 't1/2 Theory');

	%%{
		IIo   = [0.75, 0.98]; 
		IIo_line_color = 'None'; % [0, 0, 1];
		IIo_panel_color = [0.9, 0.9, 1;
					0.85, 0.85, 1;
					0.8, 0.8, 1];
		panel_plot(fig2, ax2, concs2, i_theory', IIo, IIo_line_color, IIo_panel_color);
	%%}
		contour(ax1, xlog_concs, ylog_concs, i_theory', [Io Io], 'b:', 'LineWidth', 3);
		contour(ax2, xlog_concs, ylog_concs, t_half_theory', [T1_2 T1_2], 'r:', 'LineWidth', 3);

		default_conc_plot(ax1, concs2, default_conc2);
		default_conc_plot(ax2, concs2, default_conc2);

		if dims{i} == [3,1]
			RGS = concs2{1};
			DA  = 0.5;
			AC  = obtain_conc('AC1', sd{1,1}, 0);

			xlog_concs = log10(concs2{1});
			ylog_concs = log10(concs2{2});
			
			D2R   = i_theory_asymptotic(RGS, DA, Io, params, AC);
			D2R_2 = i_theory_asymptotic2(RGS, DA, Io, params, AC);
			plot(ax1, xlog_concs, log10(D2R)   ,'--','LineWidth',2, 'Color', grey);
			plot(ax1, xlog_concs, log10(D2R_2) ,'--','LineWidth',2, 'Color', grey);


			D2R   = t_theory_asymptotic(RGS, DA, T1_2, params, AC);
			plot(ax2, xlog_concs, log10(D2R),'--','LineWidth',2 , 'Color', grey);
		end

	end


%%%
%%% Functions
%%%

function [fig, ax] = fig_prep2(targs, concs, t_title)

	xlog_concs = log10(concs{1});
	ylog_concs = log10(concs{2});
	xminmax = [ min(xlog_concs) , max(xlog_concs) ];
	yminmax = [ min(ylog_concs) , max(ylog_concs) ];
	zminmax = [ 0, 1.0 ];
	[fig, ax] = panel_prep2(xminmax, yminmax, zminmax, targs{1}, targs{2});
	title(ax,  t_title);
	xticks([-2:2]);
	yticks([-2:2]);
	hold on;
end


function panel_plot(fig, ax, concs, i_theory,  Io, Io_line_color, Io_panel_color);

	xlog_concs = log10(concs{1});
	ylog_concs = log10(concs{2});
	xminmax = [ min(xlog_concs) , max(xlog_concs) ];
	yminmax = [ min(ylog_concs) , max(ylog_concs) ];

	colormap(fig, Io_panel_color);
	caxis([min(Io), max(Io)]);

	[M,c] = contourf(ax, xlog_concs, ylog_concs, i_theory, Io, 'EdgeColor', Io_line_color);

end


function default_conc_plot(ax, concs, default_conc);

	xlog_concs = log10(concs{1});
	ylog_concs = log10(concs{2});
	xminmax = [ min(xlog_concs) , max(xlog_concs) ];
	yminmax = [ min(ylog_concs) , max(ylog_concs) ];
	x_default_conc = log10( default_conc{1} );
	y_default_conc = log10( default_conc{2} );

	plot(ax, xminmax, [ y_default_conc, y_default_conc ], 'k:');
	plot(ax, [ x_default_conc, x_default_conc ], yminmax, 'k:');
end


function [ sd, i_simulation, t_half_simulation ] = sim_2d(concs, targs, species, model, Toffset)

	nums = [numel(concs{1}), numel(concs{2})] ;
	sd 		= cell( nums );
	t_half_simulation = zeros( nums );
	i_simulation      = zeros( nums );

	reserv1 = species{targs{1},'Obj'}.InitialAmount;
	reserv2 = species{targs{2},'Obj'}.InitialAmount;
	fprintf('Target1: %s \n', targs{1});
	fprintf('Target2: %s \n', targs{2});
	fprintf('\n');

	for i = 1:nums(1);
		for j = 1:nums(2);
				species{targs{1},'Obj'}.InitialAmount = concs{1}(i) ;
				species{targs{2},'Obj'}.InitialAmount = concs{2}(j) ;
				sd{i,j}   = sbiosimulate(model);
				
				%% time
				t_half_simulation(i,j) = obtain_half('Gi_unbound_AC', sd{i,j}, Toffset);
				
				%% Inhibition
				AC1tot = obtain_conc('AC1', sd{i,j}, 0);
				AC1GTP = obtain_conc('AC1_Gi_GTP', sd{i,j}, Toffset);
				AC1GDP = obtain_conc('AC1_Gi_GDP', sd{i,j}, Toffset);
				i_simulation(i,j) = ( AC1GTP + AC1GDP )./AC1tot;
		end
	end

	species{targs{1},'Obj'}.InitialAmount = reserv1;
	species{targs{2},'Obj'}.InitialAmount = reserv2;

end


function [ i_theory, t_half_theory ] = theory_2d(sd, concs, targs, species, model, Toffset, params)

	nums = [numel(concs{1}), numel(concs{2})] ;
	t_half_theory = zeros( nums );
	i_theory      = zeros( nums );

	Km_hyd_Gi   = params{'Km_hyd_Gi','Obj'}.Value;
	kcat_hyd_Gi = params{'kcat_hyd_Gi','Obj'}.Value;
	koff_AC_GiGTP  = params{'koff_AC_GiGTP','Obj'}.Value;
	kon_AC_GiGTP   = params{'kon_AC_GiGTP','Obj'}.Value;

	kcat_exch_Gi   = params{'kcat_exch_Gi','Obj'}.Value;
	Km_exch_Gi     = params{'Km_exch_Gi','Obj'}.Value;
	kon_Gbc_Gi     = params{'kon_Gbc_Gi','Obj'}.Value;
	koff_AC_GiGDP  = params{'koff_AC_GiGDP','Obj'}.Value;

	for i = 1:nums(1);
		for j = 1:nums(2);
			%%
				RGS    = obtain_conc('RGS', sd{i,j}, 0);
				DA_D2R = obtain_conc('DA_D2R', sd{i,j}, Toffset);
				ACtot = obtain_conc('AC1', sd{i,j}, 0);
				kRGS = RGS * kcat_hyd_Gi ./ Km_hyd_Gi;
				vD2R = DA_D2R * kcat_exch_Gi;
				Gi_GTP = vD2R / kRGS;

			%% T
				Kd_AC_GiGTP = koff_AC_GiGTP/kon_AC_GiGTP;
				Co = vD2R/kRGS; % AC_Go + Go
				b  = -(Co + Kd_AC_GiGTP + ACtot);
				c  = Co * ACtot;
				AC_Go  = 0.5*( -b - sqrt( b * b - 4 * c ) );

				numerator   = AC_Go * (AC_Go - 2* (Kd_AC_GiGTP + ACtot));
				denominator = Co*( 4*ACtot - 2*AC_Go );
				t_half_theory(i,j) = 1./ kRGS * log(-denominator./numerator );
				
			%% I
				tmp = (1/kRGS + 1/koff_AC_GiGDP);
				a   = 1;
				b   = -( tmp * vD2R / ACtot + 1 + (koff_AC_GiGTP + kRGS)/kon_AC_GiGTP/ACtot  );
				c   = tmp * vD2R / ACtot;
				i_theory(i,j)  = ( -b - sqrt(b*b-4*a*c) )/(2*a);
			%%
		end
	end

end



function D2R = t_theory_asymptotic(RGS, DA, t, params, AC)

	kb_DA_D2R   = params{'kb_DA_D2R','Obj'}.Value;
	kf_DA_D2R   = params{'kf_DA_D2R','Obj'}.Value;
	Kd_DA_D2R   = kb_DA_D2R ./ kf_DA_D2R;

	Km_hyd_Gi   = params{'Km_hyd_Gi','Obj'}.Value;
	kcat_hyd_Gi = params{'kcat_hyd_Gi','Obj'}.Value;
	koff_AC_GiGTP  = params{'koff_AC_GiGTP','Obj'}.Value;
	kon_AC_GiGTP   = params{'kon_AC_GiGTP','Obj'}.Value;

	kcat_exch_Gi   = params{'kcat_exch_Gi','Obj'}.Value;
	Km_exch_Gi     = params{'Km_exch_Gi','Obj'}.Value;
	kon_Gbc_Gi     = params{'kon_Gbc_Gi','Obj'}.Value;
	koff_AC_GiGDP  = params{'koff_AC_GiGDP','Obj'}.Value;

	kRGS  = RGS .* kcat_hyd_Gi ./ Km_hyd_Gi ;

	const = (DA+Kd_DA_D2R)./(kcat_exch_Gi*DA) ;

%	D2R = const .* 4./3 .* (3.*AC -  Kd_DA_D2R ) * kRGS;
%	D2R = const .* ( 3.*AC - Kd_DA_D2R -4 .* kRGS .* t .* AC ) ./ (3./4./kRGS + t);
%	tmp = 2.*( AC + Kd_DA_D2R ) + ( 1-4.* exp(-kRGS.*t) ) .* (AC+Kd_DA_D2R);
%	tmp = ( AC + Kd_DA_D2R ) .* ( 1 - 2.* exp(-kRGS.*t) ) ./ exp(-kRGS.*t);
%	D2R = const .* kRGS .* tmp;

	Kd_AC_GiGTP = koff_AC_GiGTP/kon_AC_GiGTP;;

	D2R = const .* AC .* kRGS .* exp(kRGS.*t) .* (1 + 2.*Kd_AC_GiGTP./ AC );
end



function D2R = i_theory_asymptotic(RGS, DA, I, params, AC)

	kb_DA_D2R   = params{'kb_DA_D2R','Obj'}.Value;
	kf_DA_D2R   = params{'kf_DA_D2R','Obj'}.Value;
	Kd_DA_D2R   = kb_DA_D2R ./ kf_DA_D2R;

	Km_hyd_Gi   = params{'Km_hyd_Gi','Obj'}.Value;
	kcat_hyd_Gi = params{'kcat_hyd_Gi','Obj'}.Value;
	koff_AC_GiGTP  = params{'koff_AC_GiGTP','Obj'}.Value;
	kon_AC_GiGTP   = params{'kon_AC_GiGTP','Obj'}.Value;

	kcat_exch_Gi   = params{'kcat_exch_Gi','Obj'}.Value;
	Km_exch_Gi     = params{'Km_exch_Gi','Obj'}.Value;
	kon_Gbc_Gi     = params{'kon_Gbc_Gi','Obj'}.Value;
	koff_AC_GiGDP  = params{'koff_AC_GiGDP','Obj'}.Value;

	kRGS = RGS .* kcat_hyd_Gi ./ Km_hyd_Gi;

	const = (DA+Kd_DA_D2R)./(kcat_exch_Gi*DA)*I./(1-I)*koff_AC_GiGDP./kon_AC_GiGTP ;
	const2 = (DA+Kd_DA_D2R)./(kcat_exch_Gi*DA) ;

	D2R = const .* ( kRGS + (koff_AC_GiGTP - koff_AC_GiGDP)./(1+(koff_AC_GiGDP./kRGS)) + kon_AC_GiGTP .*(1-I) .* AC) - ...
			const2*koff_AC_GiGTP.*koff_AC_GiGDP.*I.*AC./(koff_AC_GiGDP + kRGS);

	D2R = const .* ( kRGS + (koff_AC_GiGTP - koff_AC_GiGDP)./(1+(koff_AC_GiGDP./kRGS)) + kon_AC_GiGTP .*(1-I) .* AC) ;

end


function D2R = i_theory_asymptotic2(RGS, DA, I, params, AC)

	kb_DA_D2R   = params{'kb_DA_D2R','Obj'}.Value;
	kf_DA_D2R   = params{'kf_DA_D2R','Obj'}.Value;
	Kd_DA_D2R   = kb_DA_D2R ./ kf_DA_D2R;

	Km_hyd_Gi   = params{'Km_hyd_Gi','Obj'}.Value;
	kcat_hyd_Gi = params{'kcat_hyd_Gi','Obj'}.Value;
	koff_AC_GiGTP  = params{'koff_AC_GiGTP','Obj'}.Value;
	kon_AC_GiGTP   = params{'kon_AC_GiGTP','Obj'}.Value;

	kcat_exch_Gi   = params{'kcat_exch_Gi','Obj'}.Value;
	Km_exch_Gi     = params{'Km_exch_Gi','Obj'}.Value;
	kon_Gbc_Gi     = params{'kon_Gbc_Gi','Obj'}.Value;
	koff_AC_GiGDP  = params{'koff_AC_GiGDP','Obj'}.Value;

	kRGS = RGS .* kcat_hyd_Gi ./ Km_hyd_Gi;

	Kd_AC_GiGTP = koff_AC_GiGTP/kon_AC_GiGTP;;
%	const = (DA+Kd_DA_D2R)./(kcat_exch_Gi*DA)*I./(1-I)*koff_AC_GiGDP./kon_AC_GiGTP ;
	D2R = (DA+Kd_DA_D2R)./(kcat_exch_Gi*DA).* I./(1-I) .* ( I - (1+Kd_AC_GiGTP./AC) ) .* AC .* kRGS ;

end



