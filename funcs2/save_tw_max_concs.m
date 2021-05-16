%%
%%
%%
function save_tw_max_concs(sd, sd_noDAdip, sd_noCa, targs, data_dir, container);

	T_VGCC = container('Toffset_VGCC');
	Toffset_VGCC = T_VGCC.Value;

	for k = 1:numel(targs);
		maxconcs = max_concs(targs{k}, sd, Toffset_VGCC);
		save(sprintf('%s/maxconcs_%s.mat', data_dir, targs{k}), 'maxconcs');

		maxconc_noDAdip = max_concs(targs{k}, sd_noDAdip, Toffset_VGCC);
		save(sprintf('%s/maxconc_noDAdip_%s.mat', data_dir, targs{k}), 'maxconc_noDAdip');

		maxconc_noCa = max_concs(targs{k}, sd_noCa, Toffset_VGCC);
		save(sprintf('%s/maxconc_noCa_%s.mat', data_dir, targs{k}), 'maxconc_noCa');
	end
end
