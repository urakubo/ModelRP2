function [T, DATA] = obtain_profile(tname, sd, Toffset);
	tid = find( strcmp( sd.DataNames, tname ) ) ;
	T = sd.Time - Toffset;
	DATA = sd.Data(:,tid);
	[T, id_unique] = unique(T);
	DATA = DATA(id_unique);
end
