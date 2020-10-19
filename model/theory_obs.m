
function [ i_theory, t_half_theory ] = theory_obs(mD2R, mAC, mRGS, params)

	Km_hyd_Gi     = params{'Km_hyd_Gi','Obj'}.Value;
	kcat_hyd_Gi   = params{'kcat_hyd_Gi','Obj'}.Value;
	koff_AC_GiGTP = params{'koff_AC_GiGTP','Obj'}.Value;
	kon_AC_GiGTP  = params{'kon_AC_GiGTP','Obj'}.Value;
	Kd_AC_GiGTP   = koff_AC_GiGTP/kon_AC_GiGTP;

	kcat_exch_Gi   = params{'kcat_exch_Gi','Obj'}.Value;
	Km_exch_Gi     = params{'Km_exch_Gi','Obj'}.Value;
	kon_Gbc_Gi     = params{'kon_Gbc_Gi','Obj'}.Value;
	koff_AC_GiGDP  = params{'koff_AC_GiGDP','Obj'}.Value;

	kf_DA_D2R = params{'kf_DA_D2R','Obj'}.Value;
	kb_DA_D2R = params{'kb_DA_D2R','Obj'}.Value;
	Kd_DA     = kb_DA_D2R / kf_DA_D2R;
	DAo       = 0.5;
	k_DA      = kcat_exch_Gi .* DAo ./ (DAo + Kd_DA);

	%%
	D2Rtot = mD2R;
	ACtot  = mAC;
	RGStot = mRGS;
	%%
	kRGS = RGStot .* kcat_hyd_Gi ./ Km_hyd_Gi;
	vD2R = k_DA .* D2Rtot;
	Gi_GTP = vD2R ./ kRGS;
	%%
		
	%% T1/2
	Co = vD2R./kRGS; %
	b  = -(Co + Kd_AC_GiGTP + ACtot);
	c  = Co .* ACtot;
	AC_Go  = 0.5.*( -b - sqrt( b .* b - 4 .* c ) );

	numerator     = AC_Go .* (AC_Go - 2.*(Kd_AC_GiGTP + ACtot));
	denominator   = Co.*( 4*ACtot - 2*AC_Go );
	t_half_theory = 1./ kRGS .* log(-denominator./numerator );
	
	%% Io
	tmp = (1./kRGS + 1./koff_AC_GiGDP);
	a   = 1;
	b   = -( tmp .* vD2R ./ ACtot + 1 + (koff_AC_GiGTP + kRGS)./kon_AC_GiGTP./ACtot  );
	c   = tmp .* vD2R ./ ACtot;
	i_theory  = ( -b - sqrt(b.*b-4*a.*c) )/(2.*a);

end
