%%%
%%%
%%%
function reactionObj = Reac21(input1, input2, output, kf, kb, model);

	reactionObj = addreaction(model, sprintf('%s + %s <-> %s', input1, input2, output));
	kineticsObj = addkineticlaw(reactionObj,'MassAction');
	%Kf_name   = sprintf('kf%04d', eid);
	%Kb_name   = sprintf('kb%04d', eid);
	%addparameter( kineticsObj, Kf_name , 'Value', kf );
	%addparameter( kineticsObj, Kb_name , 'Value', kb );
	kineticsObj.ParameterVariableNames = {kf, kb};

	%kineticsObj
	%reactionObj
	%get (kineticsObj, 'Parameters')


