%%
%%
%%
function max_val = maxmin_concs(tname, sd, Timing, Tstart, Tend, Toffset, maxmin)

	max_val = [];
	for i = 1: numel(Timing);
		tid = find( strcmp( sd{1}.DataNames, tname ) );
		time = sd{i}.Time - Toffset;
		data = sd{i}.Data(:,tid);
		id = find((time >= Tstart)&(time <= Tend));
		if maxmin == 'max';
			max_val = [max_val, max(data(id))];
		elseif maxmin == 'min';
			max_val = [max_val, min(data(id))];
		end
	end;

	%x0=2;
	%y0=2;
	%width=4;
	%height=3;


