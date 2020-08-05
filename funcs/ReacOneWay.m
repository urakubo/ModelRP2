
%%%
%%%
%%%
function reactionObj = ReacOneWay(input, output, kf, model);

	reactionObj = addreaction(model, sprintf('%s -> %s', input, output));
	kineticsObj = addkineticlaw(reactionObj,'MassAction');
	%Kf_name   = sprintf('kf%04d', eid);
	%addparameter( kineticsObj, Kf_name , 'Value', kf );
	kineticsObj.ParameterVariableNames = {kf};

	%kineticsObj
	%reactionObj
	%get (kineticsObj, 'Parameters')


