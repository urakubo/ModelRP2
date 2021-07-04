
%%%
%%%
%%%
function reactionObj = ReacEnzBasal(sub, enz, prod, Km, kcat, basal, model);


	reactionObj = addreaction(model, sprintf('%s -> %s', sub, prod));
	kineticsObj = addkineticlaw(reactionObj,'Unknown');
	%Km_name   = sprintf('Km%04d', eid);
	%kcat_name = sprintf('kcat%04d', eid);
	%addparameter( kineticsObj, Km  	);
	%addparameter( kineticsObj, kcat );
	
	rate_expression = sprintf('[%s]*%s*%s/([%s]+%s)-[%s]*%s*%s/([%s]+%s)', ...
		kcat, sub, enz, Km, sub, ...
		kcat, basal, enz, Km, basal );
	set (reactionObj, 'ReactionRate', rate_expression);


	%kineticsObj
	%reactionObj
	%get (kineticsObj, 'Parameters')

