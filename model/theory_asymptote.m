
function D2R = theory_asymptote(RGS, params, ACtot, Golftot, mode, flag_competitive)

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
	DAbasal     = 0.5;
	DAdip       = 0.05;
	kDA_basal   = kcat_exch_Gi .* DAbasal  ./ (DAbasal + Kd_DA);
	kDA_dip     = kcat_exch_Gi .* DAdip    ./ (DAdip   + Kd_DA);

	kon_AC_Golf  = params{'kon_AC_Golf','Obj'}.Value;
	koff_AC_Golf = params{'koff_AC_Golf','Obj'}.Value;
	Kd_AC_Golf       = koff_AC_Golf / kon_AC_Golf;
	Golf = Golftot ./ Kd_AC_Golf;

	% GTPo   = vD2Ro   ./ kRGS;
	% GTPdip = vD2Rdip ./ kRGS;

	
	switch mode
		case 'T1_2'
			T1_2 = 0.5;
			k = kDA_basal - kDA_dip;
			if (flag_competitive == 0)
				D2R = ( ACtot + 2.*Kd_AC_GiGTP ) .* kRGS ./ 2 ./ ( k .* exp(-kRGS.*T1_2) + kDA_dip);
			else
				D2R = ( ACtot + 2.*Kd_AC_GiGTP.*(1+Golf) ) .* kRGS ./ 2 ./ ( k .* exp(-kRGS.*T1_2) + kDA_dip);
			end
		case 'ACbasal'
			ACbasal = 0.3;
			if (flag_competitive == 0)
				D2R_1 = (1-ACbasal)./kDA_basal .* (ACtot + Kd_AC_GiGTP ./ACbasal ) .* kRGS;
				D2R_2 = (1-ACbasal)./kDA_basal .* koff_AC_GiGDP .* (ACtot + 1 ./ kon_AC_GiGTP ./ ACbasal .*  kRGS ) ;
			else
				D2R_1 = (1-ACbasal)./kDA_basal .* (ACtot + Kd_AC_GiGTP .* (1+Golf) ./ACbasal ) .* kRGS;
				D2R_2 = (1-ACbasal)./kDA_basal .* koff_AC_GiGDP .* (ACtot + (1+Golf) ./ kon_AC_GiGTP ./ ACbasal .*  kRGS ) ;
			end
			D2R = [D2R_1;D2R_2];
		case 'ACdip'
			ACdip = 0.7;
			if (flag_competitive == 0)
				D2R_1 = (1-ACdip)./kDA_dip .* (ACtot + Kd_AC_GiGTP ./ACdip ) .* kRGS;
				D2R_2 = (1-ACdip)./kDA_dip .* koff_AC_GiGDP .* (ACtot + 1 ./ kon_AC_GiGTP ./ ACdip .*  kRGS ) ;
			else
				D2R_1 = (1-ACdip)./kDA_dip .* (ACtot + Kd_AC_GiGTP .* (1+Golf) ./ACdip ) .* kRGS;
				D2R_2 = (1-ACdip)./kDA_dip .* koff_AC_GiGDP .* (ACtot + (1+Golf) ./ kon_AC_GiGTP ./ ACdip .*  kRGS ) ;
			end
			D2R = [D2R_1;D2R_2];
	end

end

