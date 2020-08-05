%%%
%%%
%%%
function reactionObj = Reac11(input, output, kf, kb, model);

	reactionObj = addreaction(model, sprintf('%s <-> %s', input, output));
	kineticsObj = addkineticlaw(reactionObj,'MassAction');
	%Kf_name   = sprintf('kf%04d', eid);
	%Kb_name   = sprintf('kb%04d', eid);
	%addparameter( kineticsObj, kf );
	%addparameter( kineticsObj, kb );
	kineticsObj.ParameterVariableNames = {kf, kb};

	%kineticsObj
	%reactionObj
	%get (kineticsObj, 'Parameters')



