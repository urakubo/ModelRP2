function t_half = obtain_half(tname, sd, Toffset);

	[T, DATA] = obtain_profile(tname, sd, Toffset);
	
	y0		= interp1(T, DATA, [0]);
	yend    = DATA(end);
	yhalf	= (y0 + yend) / 2;
	
	id		= find(T >= 0);
	T		= T(id);
	DATA	= DATA(id);
	DATA	= DATA - yhalf;
	
	tmp     = DATA(2:end,:) .* DATA(1:end-1,:);
	id_half = find(tmp <= 0);
	DATA    = abs(DATA);
	t_half  = DATA(id_half+1)*T(id_half)+DATA(id_half)*T(id_half+1);
	t_half  = t_half./(DATA(id_half+1) + DATA(id_half) );

	
	% tmp     = DATA(2:end,:) .* DATA(1:end-1,:);
	% id_half = find(tmp <= 0);
	% t_half  = T(id_half);
	%% fprintf('id_half: %g\n',id_half);
	%% fprintf('t_half: %g\n',t_half);
end
