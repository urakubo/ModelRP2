%%
%%
function container = stim_Golf(model, Toffset_Golf, duration_Golf);
%%
%%
	d_Golf = addparameter(model, 'duration_Golf' , duration_Golf);
	T_Golf = addparameter(model, 'Toffset_Golf'  , Toffset_Golf);
	container = containers.Map({'duration_Golf', 'Toffset_Golf'}, {d_Golf, T_Golf});

	id_Golf = find(string({model.Species.Name}) == "Golf");
	Golf_init = model.Species(id_Golf).Value;

	Golf_basal = addparameter(model, 'Golf_basal', Golf_init*0.2);
	Golf_burst = addparameter(model, 'Golf_burst', Golf_init);
	container('Golf_basal') = Golf_basal;
	container('Golf_burst') = Golf_burst;
	
	e1   = addevent(model,'time>0'      				    , 'Golf = Golf_basal' );
	e1   = addevent(model,'time>=Toffset_Golf+0'      	    , 'Golf = Golf_burst' );
	e1   = addevent(model,'time>=Toffset_Golf+duration_Golf', 'Golf = Golf_basal' );

end

