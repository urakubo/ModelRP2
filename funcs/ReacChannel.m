
%%%
%%%
%%%
function reactionObj = ReacChannel(input, channel, output, kflux, model);


	reactionObj = addreaction(model, sprintf('%s -> %s', input, output));
	kineticsObj = addkineticlaw(reactionObj,'Unknown');
	%kflux_name   = sprintf('Kflux%04d', eid);
	%addparameter( kineticsObj, kflux_name  , 'Value',  kflux );
	
	rate_expression = sprintf('[%s]*%s*%s', kflux, input, channel);
	set (reactionObj, 'ReactionRate', rate_expression);


	%kineticsObj
	%reactionObj
	%get (kineticsObj, 'Parameters')
