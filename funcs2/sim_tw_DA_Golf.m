%%
%%
%%
function [sd, sd_noDAdip, sd_constGolf] = sim_tw_DA_Golf(model, DA_delay, container)


	T_DA   = container('Toffset_DA');
	d_DA   = container('duration_DA');
	T_Golf   = container('Toffset_Golf');

	Toffset_Golf = T_Golf.Value;
	reserv_      = T_DA.Value;

	num_DA_delay = numel(DA_delay);
	sd   = cell(num_DA_delay, 1);
	for i = 1:num_DA_delay;
		fprintf('DA timing: %d / %d \n', i, num_DA_delay );
		T_DA.Value = DA_delay(i) + Toffset_Golf;
		sd{i,1} = sbiosimulate(model);
	end;

	T_DA.Value   = reserv_;

	reserv_      = d_DA.Value;
	d_DA.Value   = 0.0;
	sd_noDAdip   = sbiosimulate(model);
	d_DA.Value   = reserv_;

	reserv_         = T_Golf.Value;
	stop_time       = get(getconfigset(model), 'StopTime');
	T_Golf.Value    = stop_time + 1;
	sd_constGolf    = sbiosimulate(model);
	T_Golf.Value    = reserv_;

end
%%
%%
%%
