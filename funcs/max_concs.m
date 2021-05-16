%%
%%
%%
function max_val = max_concs(tname, sd, Tstart, varargin)

% The last parameter: Tend

	if numel(sd) > 1

		max_val = [];
		target_id  = find( strcmp( sd{1}.DataNames, tname ) );

		for i = 1: numel(sd);
			t = sd{i}.Time;
			
			if nargin == 4
				time_id = find((t >= Tstart)&(t <= varargin));
			else
				time_id = find(t >= Tstart);
			end
			data = sd{i}.Data(time_id, target_id);

			max_val = [max_val, max(data)];
		end;

	else

		target_id = find( strcmp( sd.DataNames, tname ) );
		t = sd.Time;
		if nargin == 4
			time_id = find((t >= Tstart)&(t <= varargin));
		else
			time_id = find(t >= Tstart);
		end

%		fprintf('numel(sd.Time): %g\n', numel(sd.Time));
%		fprintf('Tstart: %g\n', Tstart);
%		fprintf('time:%g, targ: %g\n',time_id, target_id);

		data = sd.Data(time_id, target_id);
		max_val = max(data);

	end

