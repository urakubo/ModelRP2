%%
%%
%%
function max_val = end_concs(tname, sd, Timing, Tstart, Tend, Toffset)

	max_val = [];
	for i = 1: numel(Timing);
		tid = find( strcmp( sd{1}.DataNames, tname ) );
		time = sd{i}.Time - Toffset;
		data = sd{i}.Data(:,tid);
		id = find((time >= Tstart)&(time <= Tend));
		id = max(id);
		max_val = [max_val, data(id)];
	end;

	%x0=2;
	%y0=2;
	%width=4;
	%height=3;


