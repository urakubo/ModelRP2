
function [ io_theory, idip_theory, t_half_theory ] = theory(mD2R, mAC, mRGS, params)

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


	DAo         = 0.5;
	DAdip       = 0.05;
	k_DAo       = kcat_exch_Gi .* DAo ./ (DAo + Kd_DA);
	k_DAdip     = kcat_exch_Gi .* DAdip ./ (DAdip + Kd_DA);

	%%
	D2Rtot = mD2R;
	ACtot  = mAC;
	RGStot = mRGS;
	%%
	kRGS = RGStot .* kcat_hyd_Gi ./ Km_hyd_Gi;
	vD2Ro   = k_DAo   .* D2Rtot;
	vD2Rdip = k_DAdip .* D2Rtot;
	GTPo   = vD2Ro   ./ kRGS;
	GTPdip = vD2Rdip ./ kRGS;
	%%


	%% Io
	
	tmp = (1./kRGS + 1./koff_AC_GiGDP);
	a   = 1;
	b   = -( tmp .* vD2Ro ./ ACtot + 1 + (koff_AC_GiGTP + kRGS)./kon_AC_GiGTP./ACtot  );
	c   = tmp .* vD2Ro ./ ACtot;
	io_theory  = ( -b - sqrt(b.*b-4*a.*c) )./(2.*a);
	
	%% Idip
	tmp = (1./kRGS + 1./koff_AC_GiGDP);
	a   = 1;
	b   = -( tmp .* vD2Rdip ./ ACtot + 1 + (koff_AC_GiGTP + kRGS)./kon_AC_GiGTP./ACtot  );
	c   = tmp .* vD2Rdip ./ ACtot;
	idip_theory  = ( -b - sqrt(b.*b-4*a.*c) )/(2.*a);



	%% T1/2
	b     = - (GTPo./ACtot) - 1 - (Kd_AC_GiGTP./ACtot);
	c     = GTPo ./ ACtot;
	io    = 0.5.*( -b - sqrt( b .* b - 4 .* c ) );

	b     = - (GTPdip./ACtot) - 1 - (Kd_AC_GiGTP./ACtot);
	c     = GTPdip ./ ACtot;
	idip  = 0.5.*( -b - sqrt( b .* b - 4 .* c ) );

	i_ave = (io + idip) ./ 2;
	denominator   = i_ave  .* ( ACtot + Kd_AC_GiGTP./(1-i_ave) ) - GTPdip ;
	numerator     = GTPo - GTPdip;
	t_half_theory = 1./ kRGS .* log( numerator./denominator );



%
% Only Io is considered.
%

%	denominator   = io  .* (2.* Kd_AC_GiGTP  + 2.* ACtot - io .* ACtot );
%	numerator     = 2 .* GTPo.*( 2 - io );
%	t_half_theory = 1./ kRGS .* log( numerator./denominator );


end
