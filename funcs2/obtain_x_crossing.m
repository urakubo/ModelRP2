function x_half = obtain_x_crossing(x, y, ytarg);

	[x, id_unique] = unique(x);
	y = y(id_unique) - ytarg;
	tmp     = y(2:end) .* y(1:end-1);
	id_half = find(tmp <= 0);
	if numel(id_half) < 1
		fprintf('All values are larger/smaller than %g \n', ytarg);
		x_half = NaN;
	elseif numel(id_half) > 1
		fprintf('Monre than one crossing at %g \n', ytarg);
		x_half = NaN;
	else
		y       = abs(y);
		tmp     = y(id_half+1)*x(id_half)+y(id_half)*x(id_half+1);
		x_half  = tmp./( y(id_half+1) + y(id_half) );
	end
end
