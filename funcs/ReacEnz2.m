
%%%
%%%
%%%
function reactionObj = ReacEnz2(G, enz, Ga, Gbc, Km, kcat, model);

	reactionObj = addreaction(model, sprintf('%s -> %s + %s', G, Ga, Gbc));
	kineticsObj = addkineticlaw(reactionObj,'Unknown');
	%Km_name   = sprintf('Km%04d', eid);
	%kcat_name = sprintf('kcat%04d', eid);
	%addparameter( kineticsObj, Km_name  , 'Value', Km   );
	%addparameter( kineticsObj, kcat_name, 'Value', kcat );
	
	rate_expression = sprintf('[%s]*%s*%s/([%s]+%s)', kcat, G, enz, Km, G);
	set (reactionObj, 'ReactionRate', rate_expression);


	%kineticsObj
	%reactionObj
	%get (kineticsObj, 'Parameters')


