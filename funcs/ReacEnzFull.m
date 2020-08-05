
%%%
%%%
%%%
function eid_ = ReacEnzFull(sub, enz, prod, comp, Km, kcat, model, eid);

	kf = 5 * kcat / Km;
	kb = 4 * kcat;

	reac1 = addreaction(model, sprintf('%s + %s <-> %s', sub, enz, comp));
	kine1 = addkineticlaw(reac1,'MassAction');
	kfname = sprintf('kf%04d', eid);
	kbname = sprintf('kb%04d', eid);
	addparameter(kine1,kfname,'Value',kf);
	addparameter(kine1,kbname,'Value',kb);

	kine1.ParameterVariableNames = {kfname,kbname};

	%kine1
	%reac1
	%get (kine1, 'Parameters')


	reac2 = addreaction(model, sprintf('%s -> %s + %s', comp, enz, prod));
	kine2 = addkineticlaw(reac2,'MassAction');
	kfname = sprintf('kcat%04d', eid);
	addparameter(kine2, kfname,'Value',kcat);
	kine2.ParameterVariableNames = {kfname};

	eid_ = eid + 1;


