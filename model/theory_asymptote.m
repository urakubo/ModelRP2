
function D2R = theory_asymptote(RGS, IorT, params, AC, mode)

	kb_DA_D2R   = params{'kb_DA_D2R','Obj'}.Value;
	kf_DA_D2R   = params{'kf_DA_D2R','Obj'}.Value;
	Kd_DA       = kb_DA_D2R ./ kf_DA_D2R;

	Km_hyd_Gi   = params{'Km_hyd_Gi','Obj'}.Value;
	kcat_hyd_Gi = params{'kcat_hyd_Gi','Obj'}.Value;
	koff_AC_GiGTP  = params{'koff_AC_GiGTP','Obj'}.Value;
	kon_AC_GiGTP   = params{'kon_AC_GiGTP','Obj'}.Value;

	kcat_exch_Gi   = params{'kcat_exch_Gi','Obj'}.Value;
	Km_exch_Gi     = params{'Km_exch_Gi','Obj'}.Value;
	kon_Gbc_Gi     = params{'kon_Gbc_Gi','Obj'}.Value;
	koff_AC_GiGDP  = params{'koff_AC_GiGDP','Obj'}.Value;

	kRGS  = RGS .* kcat_hyd_Gi ./ Km_hyd_Gi ;
	DAo       = 0.5;
	k_DA      = kcat_exch_Gi * DAo / (DAo + Kd_DA);

	Kd_AC_GiGTP = koff_AC_GiGTP./kon_AC_GiGTP;
	kRGS = RGS .* kcat_hyd_Gi ./ Km_hyd_Gi;
	DAo       = 0.5;
	k_DA      = kcat_exch_Gi * DAo / (DAo + Kd_DA);
	
	switch mode
		case 'T1_2'
			T1_2 = IorT;
			D2R = ( AC + 2.*Kd_AC_GiGTP )./ (2 * k_DA) .* kRGS .* exp(kRGS.*T1_2);
		case 'I1'
			I = IorT;
			D2R = I./k_DA .* koff_AC_GiGDP .* (AC +  kRGS ./ kon_AC_GiGTP ./(1-I) ) ;
		case 'I2'
			I = IorT;
			D2R = I./k_DA .* ( AC + Kd_AC_GiGTP ./ (1-I) ) .* kRGS;
	end

end

