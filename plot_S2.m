
%%
%% Please run "sim_3D" beforehand.
%%

%%%%
%%%% Init
%%%%

	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');
	font_init;

	data_dir = 'data';
	load( sprintf('%s/data.mat', data_dir));


	Km_hyd_Gi   = params{'Km_hyd_Gi','Obj'}.Value;
	kcat_hyd_Gi = params{'kcat_hyd_Gi','Obj'}.Value;
	koff_AC_GiGTP  = params{'koff_AC_GiGTP','Obj'}.Value;
	kon_AC_GiGTP   = params{'kon_AC_GiGTP','Obj'}.Value;

	kcat_exch_Gi   = params{'kcat_exch_Gi','Obj'}.Value;
	Km_exch_Gi     = params{'Km_exch_Gi','Obj'}.Value;
	kon_Gbc_Gi     = params{'kon_Gbc_Gi','Obj'}.Value;
	koff_AC_GiGDP  = params{'koff_AC_GiGDP','Obj'}.Value;


%%%%
%%%% Simulation
%%%%

	t_half_simulation     = zeros( nums );
	t_half_theory         = zeros( nums );
	i_theory              = zeros( nums );
	i_simulation          = zeros( nums );

	for i = 1:nums(1);
		fprintf('%s conc: %g uM \n', targs{1}, concs{1}(i));
		for j = 1:nums(2);
			% fprintf(' %s conc: %g uM \n', targs{2},  concs{2}(j));

			ACtot =  concs{2}(j);
			for k = 1:nums(3);

			RGS    = obtain_conc('RGS', sd{i,j,k}, 0);
			DA_D2R = obtain_conc('DA_D2R', sd{i,j,k}, Toffset);
			AC1tot = obtain_conc('AC1', sd{i,j,k}, 0);
			AC1GTP = obtain_conc('AC1_Gi_GTP', sd{i,j,k}, Toffset);
			AC1GDP = obtain_conc('AC1_Gi_GDP', sd{i,j,k}, Toffset);
			Gi_GTP = obtain_conc('Gi_GTP', sd{i,j,k}, Toffset);

			kRGS = RGS * kcat_hyd_Gi ./ Km_hyd_Gi;
			vD2R = DA_D2R * kcat_exch_Gi;
			Gi_GTP = vD2R / kRGS;

			t_half_simulation(i,j,k) = obtain_half('Gi_unbound_AC', sd{i,j,k}, Toffset);

			Kd_AC_GiGTP = koff_AC_GiGTP/kon_AC_GiGTP;
			Co = vD2R/kRGS; % AC_Go + Go
			b  = -(Co + Kd_AC_GiGTP + ACtot);
			c  = Co * ACtot;
			AC_Go  = 0.5*( -b - sqrt( b * b - 4 * c ) );

			numerator   = AC_Go * (AC_Go - 2* (Kd_AC_GiGTP + ACtot));
			denominator = Co*( 4*ACtot - 2*AC_Go );
			t_half_theory(i,j,k) = 1./ kRGS * log(-denominator./numerator );

			tmp = (1/kRGS + 1/koff_AC_GiGDP);
			a   = 1;
			b   = -( tmp * vD2R / ACtot + 1 + (koff_AC_GiGTP + kRGS)/kon_AC_GiGTP/ACtot  );
			c   = tmp * vD2R / ACtot;

			i_theory(i,j,k)  = ( -b - sqrt(b*b-4*a*c) )/(2*a);
			i_simulation(i,j,k) = ( AC1GTP + AC1GDP )./AC1tot;
			%%
			end
		end
	end


%%
%% 3D plot hydrolysis
%%

	T1_2 = 0.5  ; % 0.5
	Io   = 0.75 ; %0.75; % 0.5

	T_T = (t_half_theory     < T1_2);
	T_S = (t_half_simulation < T1_2);
	A_T = (i_theory     > Io );
	A_S = (i_simulation > Io );


%%
%% Simulation results
%%

	TITLE = 'Simulation';
	standards = [2,3,5];
	[fig, ax] = plot_area_3D(T_S, A_S, targs, concs, default_conc, TITLE, standards);
	view(ax,[-30 30]);

	standards = [2,4,5];
	[fig, ax] = plot_area_3D(T_S, A_S, targs, concs, default_conc, TITLE, standards);
	view(ax,[60 30]);

%%
%% Analytical solution
%%

	TITLE = 'Theory';
	standards = [2,3,5];
	[fig, ax] = plot_area_3D(T_T, A_T, targs, concs, default_conc, TITLE, standards);
	view(ax,[-30 30]);

	standards = [2,4,5];
	[fig, ax] = plot_area_3D(T_T, A_T, targs, concs, default_conc, TITLE, standards);
	view(ax,[60 30]);


