%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	font_init;


	check = 0;
%	check = 1;
	[model, species, params, Toffset] = msn_setup(check);
	% check == 0: normal; 
	% check == 1 AC1 binding do not affect Gi conc.

%%%

	targs = {'D2R','AC1','RGS'};

%	tmp = 10.^[-1:0.025:1];
	tmp = 10.^[-1:0.1:1];
	concs{1} 		= tmp;
	concs{2} 		= tmp;
	concs{3} 		= tmp;


	for i = 1:3;
		default_conc{i} = species{targs{i},'Obj'}.InitialAmount;
		concs{i} 		= concs{i} .* default_conc{i};
		fprintf('Original conc %s: %g uM \n', targs{i}, default_conc{i} );
	end

	T1_2  = 0.5; 
	Io    = 0.75; 

%%
%% 2D plot 
%%
	dims = { [2,1], [3,1], [3,2] };
%	dims = { [3,2] };

	for  i = 1:numel(dims);
		concs2 = concs(dims{i});
		targs2 = targs(dims{i});
		default_conc2 = default_conc(dims{i});

		[sd, i_simulation, t_half_simulation] = sim_2d(concs2, targs2, species, model, Toffset);
		T_HALF = (t_half_simulation < T1_2);
		INH    = (i_simulation > Io);
		ax = panel_plot2(targs2, concs2, T_HALF, INH, default_conc2, 'Simulation');

		[ i_theory, t_half_theory ] = theory_2d(sd, concs2, targs2, species, model, Toffset, params);
		T_HALF = (t_half_simulation < T1_2);
		INH    = (i_simulation > Io);
		% panel_plot2(targs2, concs2, T_HALF, INH, default_conc2, 'Theory');

		xlog_concs = log10(concs2{1});
		ylog_concs = log10(concs2{2});		
		contour(ax, xlog_concs, ylog_concs,  t_half_theory', [T1_2 T1_2],'r:','LineWidth',2);
		contour(ax, xlog_concs, ylog_concs,  i_theory', [Io Io],'b:','LineWidth',2);

	end


%%%
%%% Functions
%%%

function ax = panel_plot2(targs, concs, T_HALF, INH, default_conc, t_title )


	xlog_concs = log10(concs{1});
	ylog_concs = log10(concs{2});
	xminmax = [ min(xlog_concs) , max(xlog_concs) ];
	yminmax = [ min(ylog_concs) , max(ylog_concs) ];
	zminmax = [ 0, 1.0 ];
	x_default_conc = default_conc{1};
	y_default_conc = default_conc{2};

	ax = panel_prep(xminmax, yminmax, zminmax, targs{1}, targs{2});
	title(ax,  t_title);
	mymap = [1 1 1;0 0 1;1 0 0];
	colormap(mymap);
	im1 = imagesc( ax, 'XData', xlog_concs,'YData', ylog_concs, 'CData', T_HALF', zminmax );
	im1.AlphaData = .3;

	mymap = [1 1 1;0 0 1;1 0 0];
	colormap(mymap);
	im2 = imagesc( ax, 'XData', xlog_concs,'YData', ylog_concs, 'CData', 0.5*INH', zminmax );
	im2.AlphaData = .3;

	plot(ax, xminmax, [log10(y_default_conc) log10(y_default_conc)], 'k:');
	plot(ax, [ log10(x_default_conc), log10(x_default_conc) ], yminmax, 'k:');
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
			%%
				kRGS = RGS * kcat_hyd_Gi ./ Km_hyd_Gi;
				vD2R = DA_D2R * kcat_exch_Gi;
				Gi_GTP = vD2R / kRGS;
			%%
				
				%% time
				Kd_AC_GiGTP = koff_AC_GiGTP/kon_AC_GiGTP;
				Co = vD2R/kRGS; % AC_Go + Go
				b  = -(Co + Kd_AC_GiGTP + ACtot);
				c  = Co * ACtot;
				AC_Go  = 0.5*( -b - sqrt( b * b - 4 * c ) );

				numerator   = AC_Go * (AC_Go - 2* (Kd_AC_GiGTP + ACtot));
				denominator = Co*( 4*ACtot - 2*AC_Go );
				t_half_theory(i,j) = 1./ kRGS * log(-denominator./numerator );
				
				%% Inhibition
				tmp = (1/kRGS + 1/koff_AC_GiGDP);
				a   = 1;
				b   = -( tmp * vD2R / ACtot + 1 + (koff_AC_GiGTP + kRGS)/kon_AC_GiGTP/ACtot  );
				c   = tmp * vD2R / ACtot;
				i_theory(i,j)  = ( -b - sqrt(b*b-4*a*c) )/(2*a);

		end
	end

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


