%%%
%%%
%%%
function eid_ = Reac1(input, output, kf, kb, model, eid);

	reactionObj = addreaction(model, sprintf('%s <-> %s', input, output));
	kineticsObj = addkineticlaw(reactionObj,'MassAction');
	Kf_name   = sprintf('kf%02d', eid);
	Kb_name   = sprintf('kb%02d', eid);
	addparameter( kineticsObj, Kf_name , 'Value', kf );
	addparameter( kineticsObj, Kb_name , 'Value', kb );
	kineticsObj.ParameterVariableNames = {Kf_name, Kb_name};

	%kineticsObj
	%reactionObj
	%get (kineticsObj, 'Parameters')

	eid_ = eid + 1;

%%%
%%%
%%%
function eid_ = ReacOneWay(input, output, kf, model, eid);

	reactionObj = addreaction(model, sprintf('%s -> %s', input, output));
	kineticsObj = addkineticlaw(reactionObj,'MassAction');
	Kf_name   = sprintf('kf%02d', eid);
	addparameter( kineticsObj, Kf_name , 'Value', kf );
	kineticsObj.ParameterVariableNames = {Kf_name};

	%kineticsObj
	%reactionObj
	%get (kineticsObj, 'Parameters')

	eid_ = eid + 1;


%%%
%%%
%%%
function eid_ = ReacEnz(sub, enz, prod, Km, kcat, model, eid);


	reactionObj = addreaction(model, sprintf('%s -> %s', sub, prod));
	kineticsObj = addkineticlaw(reactionObj,'Unknown');
	Km_name   = sprintf('Km%02d', eid);
	kcat_name = sprintf('kcat%02d', eid);
	addparameter( kineticsObj, Km_name  , 'Value', Km   );
	addparameter( kineticsObj, kcat_name, 'Value', kcat );
	
	rate_expression = sprintf('[%s]*%s*%s/([%s]+%s)', kcat_name, sub, enz, Km_name, sub);
	set (reactionObj, 'ReactionRate', rate_expression);


	%kineticsObj
	%reactionObj
	%get (kineticsObj, 'Parameters')

	eid_ = eid + 1;


%%%
%%%
%%%
function eid_ = ReacEnzFull(sub, enz, prod, comp, Km, kcat, model, eid);

	kf = 5 * kcat / Km;
	kb = 4 * kcat;

	reac1 = addreaction(model, sprintf('%s + %s <-> %s', sub, enz, comp));
	kine1 = addkineticlaw(reac1,'MassAction');
	kfname = sprintf('kf%02d', eid);
	kbname = sprintf('kb%02d', eid);
	addparameter(kine1,kfname,'Value',kf);
	addparameter(kine1,kbname,'Value',kb);

	kine1.ParameterVariableNames = {kfname,kbname};

	%kine1
	%reac1
	%get (kine1, 'Parameters')


	reac2 = addreaction(model, sprintf('%s -> %s + %s', comp, enz, prod));
	kine2 = addkineticlaw(reac2,'MassAction');
	kfname = sprintf('kcat%02d', eid);
	addparameter(kine2, kfname,'Value',kcat);
	kine2.ParameterVariableNames = {kfname};

	eid_ = eid + 1;


