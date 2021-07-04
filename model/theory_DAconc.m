

function AC_primed_theory = theory_DAconc(flag_competitive, mD2R, mAC, mRGS, mGi, mGolf, DAbasal, DAdip, params)


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

	kon_AC_Golf  = params{'kon_AC_Golf','Obj'}.Value;
	koff_AC_Golf = params{'koff_AC_Golf','Obj'}.Value;
	Kd_AC_Golf   = koff_AC_Golf / kon_AC_Golf;

	k_DAo       = kcat_exch_Gi .* DAo ./ (DAo + Kd_DA);


	%%
	D2Rtot  = mD2R;
	ACtot   = mAC;
	RGStot  = mRGS;
	Golftot = mGolf;
	%%
	kRGS = RGStot .* kcat_hyd_Gi ./ Km_hyd_Gi;
	vD2Ro   = k_DAo   .* D2Rtot;
	GTPo   = vD2Ro   ./ kRGS;
	%%
	tau = (1./kRGS + 1./koff_AC_GiGDP);
	Golf = Golftot ./ Kd_AC_Golf;

	if (flag_competitive == 0)
		alpha = (koff_AC_GiGTP + kRGS)./kon_AC_GiGTP./ACtot;
		b   = ( tau .* vD2Ro ./ ACtot - 1 + alpha  );
		c   = -alpha;
		AC_primed_theory  = 0.5.*( -b + sqrt( b .* b - 4 .* c ) );
%%
%%
		%% T1/2
		b      = (Kd_AC_GiGTP./ACtot) + (GTPo./ACtot) - 1;
		c      = -Kd_AC_GiGTP./ACtot;
		Abasal = 0.5.*( -b + sqrt( b .* b - 4 .* c ) );

		b      = (Kd_AC_GiGTP./ACtot) + (GTPdip./ACtot) - 1;
		c      = -Kd_AC_GiGTP./ACtot;
		Adip  = 0.5.*( -b + sqrt( b .* b - 4 .* c ) );

		A_ave = (Abasal + Adip) ./ 2;
		denominator   = (1-A_ave)  .* ( ACtot + Kd_AC_GiGTP./A_ave ) - GTPdip ;
		numerator     = GTPo - GTPdip;
		t_half_theory = 1./ kRGS .* log( numerator./denominator );
%%
%%
	else

		alpha = (koff_AC_GiGTP + kRGS) ./ kon_AC_GiGTP ./ ACtot .* (1+Golf);
		b = vD2Ro .* tau ./ ACtot -1 + alpha;
		c = -alpha;
		AC_primed_theory  = 0.5.*( -b + sqrt( b .* b - 4 .* c ) ) ;

	end



end
