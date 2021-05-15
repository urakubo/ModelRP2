%%
%%
%%
function maxmin_val = maxmin_concs(tname, sd, Tstart, Tend, max_or_min)

	if numel(sd) > 1

		maxmin_val = [];
		target_id  = find( strcmp( sd{1}.DataNames, tname ) );

		for i = 1: numel(sd);
			time = sd{i}.Time;
			time_id = find((time >= Tstart)&(time <= Tend));
			data = sd{i}.Data(time_id, target_id);
			if max_or_min == 'max';
				maxmin_val = [maxmin_val, max(data)];
			elseif max_or_min == 'min';
				maxmin_val = [maxmin_val, min(data)];
			end
		end;

	else

		target_id = find( strcmp( sd.DataNames, tname ) );
		time_id   = find((sd.Time >= Tstart)&(sd.Time <= Tend));
		data = sd.Data(time_id, target_id);
		if max_or_min == 'max';
			maxmin_val = max(data);
		elseif max_or_min == 'min';
			maxmin_val = min(data);
		end

	end

