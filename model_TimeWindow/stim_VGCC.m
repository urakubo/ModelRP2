%%
%%
function container = stim_VGCC(model, Toffset_VGCC);
%%
%%
	VGCCplus = addparameter(model, 'VGCCplus', 0.55884);
	T_VGCC  = addparameter(model, 'Toffset_VGCC'  , Toffset_VGCC);
	container = containers.Map({'VGCCplus', 'Toffset_VGCC'}, {VGCCplus, T_VGCC});

	e1 = addevent(model,'time>=Toffset_VGCC'		,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.1'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.2'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.3'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.4'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.5'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.6'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.7'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.8'	,'VGCC = VGCC + VGCCplus');
	e1 = addevent(model,'time>=Toffset_VGCC + 0.9'	,'VGCC = VGCC + VGCCplus');

