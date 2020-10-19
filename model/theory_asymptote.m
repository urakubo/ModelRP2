
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
%	DAo       = 0.5;
%	k_DA      = kcat_exch_Gi * DAo / (DAo + Kd_DA);

	Kd_AC_GiGTP = koff_AC_GiGTP./kon_AC_GiGTP;
	kRGS = RGS .* kcat_hyd_Gi ./ Km_hyd_Gi;
	DAo         = 0.5;
	DAdip       = 0.05;
	k_DAo       = kcat_exch_Gi .* DAo ./ (DAo + Kd_DA);
	k_DAdip     = kcat_exch_Gi .* DAdip ./ (DAdip + Kd_DA);
	% vD2Ro   = k_DAo   .* D2Rtot;
	% vD2Rdip = k_DAdip .* D2Rtot;
	% GTPo   = vD2Ro   ./ kRGS;
	% GTPdip = vD2Rdip ./ kRGS;

	
	switch mode
		case 'T1_2'
			T1_2 = IorT;
			k = k_DAo - k_DAdip;
			D2R = ( AC + 2.*Kd_AC_GiGTP ) .* kRGS ./ 2 ./ ( k .* exp(-kRGS.*T1_2) + k_DAdip);
		case 'Io_1'
			I = IorT;
			D2R = I./k_DAo .* koff_AC_GiGDP .* (AC +  kRGS ./ kon_AC_GiGTP ./(1-I) ) ;
		case 'Io_2'
			I = IorT;
			D2R = I./k_DAo .* ( AC + Kd_AC_GiGTP ./ (1-I) ) .* kRGS;
		case 'Idip_1'
			I = IorT;
			D2R = I./k_DAdip .* koff_AC_GiGDP .* (AC +  kRGS ./ kon_AC_GiGTP ./(1-I) ) ;
		case 'Idip_2'
			I = IorT;
			D2R = I./k_DAdip .* ( AC + Kd_AC_GiGTP ./ (1-I) ) .* kRGS;
	end

end

