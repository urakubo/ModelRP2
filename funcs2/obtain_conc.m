function conc = obtain_conc(tname, sd, Ts);
	[T, DATA] = obtain_profile(tname, sd, 0);
	conc = interp1(T, DATA, Ts);
end
