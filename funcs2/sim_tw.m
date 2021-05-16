%%
%%
%%
function [sd, sd_noDAdip, sd_noCa] = sim_tw(model, DA_delay, container)

	T_VGCC = container('Toffset_VGCC');
	T_DA   = container('Toffset_DA');
	d_DA   = container('duration_DA');
	Toffset_VGCC = T_VGCC.Value;

	num_DA_delay = numel(DA_delay);
	sd   = cell(num_DA_delay, 1);
	for i = 1:num_DA_delay;
		fprintf('DA timing: %d / %d \n', i, num_DA_delay );
		T_DA.Value = DA_delay(i) + Toffset_VGCC;
		sd{i,1} = sbiosimulate(model);
	end;

	reserv_      = d_DA.Value;
	d_DA.Value   = 0.2;
	sd_noDAdip   = sbiosimulate(model);
	d_DA.Value   = reserv_;

	stop_time = get(getconfigset(model), 'StopTime');
	reserv_      = T_VGCC.Value;
	T_VGCC.Value = stop_time + 1;
	sd_noCa      = sbiosimulate(model);
	T_VGCC.Value = reserv_;

end
