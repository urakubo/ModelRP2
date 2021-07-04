

function [ AC_basal_theory, AC_dip_theory, t_half_theory ] = theory(flag_competitive, mD2R, mAC, mRGS, mGi, mGolf, params, varargin)

	if nargin == 7
	    DAbasal = 0.5;
		DAdip   = 0.05;
	elseif nargin == 9
	    DAbasal =  varargin{1};
	    DAdip   = varargin{2};
	else
	    fprintf('Mismach of the number of argument in Theory\n')
	    return;
	end

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
	Kd_AC_Golf       = koff_AC_Golf / kon_AC_Golf;

	k_DAbasal   = kcat_exch_Gi .* DAbasal ./ (DAbasal + Kd_DA);
	k_DAdip     = kcat_exch_Gi .* DAdip   ./ (DAdip   + Kd_DA);

	%%
	D2Rtot  = mD2R;
	ACtot   = mAC;
	RGStot  = mRGS;
	Golftot = mGolf;
	%%
	kRGS = RGStot .* kcat_hyd_Gi ./ Km_hyd_Gi;
	vD2Rbasal = k_DAbasal .* D2Rtot;
	vD2Rdip   = k_DAdip   .* D2Rtot;
	GTPbasal  = vD2Rbasal ./ kRGS;
	GTPdip    = vD2Rdip   ./ kRGS;
	%%
	tau = (1./kRGS + 1./koff_AC_GiGDP);
	Golf = Golftot ./ Kd_AC_Golf;

	if (flag_competitive == 0)
		%%
		%% Non-competitive binding
		%%
		% AC_Golf_max = Golf ./ (1 + Golf);
		alpha = (koff_AC_GiGTP + kRGS)./kon_AC_GiGTP./ACtot;
		c   = -alpha;

		b   = ( tau .* vD2Rbasal ./ ACtot - 1 + alpha  );
		AC_basal_theory  = 0.5.*( -b + sqrt( b .* b - 4 .* c ) );

		b   = ( tau .* vD2Rdip ./ ACtot - 1 + alpha  );
		AC_dip_theory  = 0.5.*( -b + sqrt( b .* b - 4 .* c ) ); 

		%% T1/2
		b      = (Kd_AC_GiGTP./ACtot) + (GTPbasal./ACtot) - 1;
		c      = -Kd_AC_GiGTP./ACtot;
		Abasal = 0.5.*( -b + sqrt( b .* b - 4 .* c ) );

		b      = (Kd_AC_GiGTP./ACtot) + (GTPdip./ACtot) - 1;
		c      = -Kd_AC_GiGTP./ACtot;
		Adip  = 0.5.*( -b + sqrt( b .* b - 4 .* c ) );

		A_ave = (Abasal + Adip) ./ 2;
		denominator   = (1-A_ave)  .* ( ACtot + Kd_AC_GiGTP./A_ave ) - GTPdip ;
		numerator     = GTPbasal - GTPdip;
		t_half_theory = 1./ kRGS .* log( numerator./denominator );

	else
		%%
		%% Competitive binding
		%%

		alpha = (koff_AC_GiGTP + kRGS) ./ kon_AC_GiGTP ./ ACtot .* (1+Golf);

		%% A_basal
		b = vD2Rbasal .* tau ./ ACtot -1 + alpha;
		c = -alpha;
		AC_basal_theory  = 0.5.*( -b + sqrt( b .* b - 4 .* c ) ) ;
		
		%% A_dip
		b = vD2Rdip .* tau ./ ACtot -1 + alpha;
		c = -alpha;
		AC_dip_theory  = 0.5.*( -b + sqrt( b .* b - 4 .* c ) );

		%% T1/2
		b      = (Kd_AC_GiGTP./ACtot) .* (1+Golf) + (GTPbasal./ACtot) - 1;
		c      = -Kd_AC_GiGTP./ACtot .* (1+Golf);
		Abasal = 0.5.*( -b + sqrt( b .* b - 4 .* c ) );

		b      = (Kd_AC_GiGTP./ACtot) .* (1+Golf) + (GTPdip./ACtot) - 1;
		c      = -Kd_AC_GiGTP./ACtot .* (1+Golf);
		Adip   = 0.5.*( -b + sqrt( b .* b - 4 .* c ) );

		A = (Abasal + Adip) ./ 2;
		% A = (A_basal_theory + A_dip_theory) ./ 2;

		denominator   = (1 - A)  .* ( ACtot + Kd_AC_GiGTP.*(1+Golf)./A ) - GTPdip ;
		numerator     = GTPbasal - GTPdip;

		t_half_theory = 1./ kRGS .* log( numerator./denominator );
	end



end
