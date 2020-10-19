%%
%%
%%
function [fig, ax] = plot_3D_panel(T, A, targs, concs, standards, col)

	T = permute(T ,[2 1 3]);
	A = permute(A ,[2 1 3]);

	xconcs = concs{1};
	yconcs = concs{2};
	zconcs = concs{3};

	xminmax = [ min(xconcs) , max(xconcs) ];
	yminmax = [ min(yconcs) , max(yconcs) ];
	zminmax = [ min(zconcs) , max(zconcs) ];

	t_not_inh =  T.*(1-A);
	inh_not_t =  A.*(1-T);
	both =  T.*A;

	f ={};
	v ={};
	[f{1},v{1}]    = isosurface(xconcs, yconcs, zconcs, t_not_inh, 0.5);
	[f{2},v{2},ic] = isocaps(xconcs, yconcs, zconcs, t_not_inh, 0.5);

	[f{3},v{3}]    = isosurface(xconcs, yconcs, zconcs, inh_not_t, 0.5);
	[f{4},v{4},ic] = isocaps(xconcs, yconcs, zconcs, inh_not_t, 0.5);

	[f{5},v{5}]    = isosurface(xconcs, yconcs, zconcs, both, 0.5);
	[f{6},v{6},ic] = isocaps(xconcs, yconcs, zconcs, both, 0.5);

	alpha = [0.2, 0.1,  0.2, 0.1, 0.2, 0.2];
	ci    = [1, 1,  2, 2, 3, 3];

%	col = {'red','red','blue','blue','magenta','magenta'};

	fig = figure;
	loc = fig.Position;
	fig.Position = [loc(1),loc(2),loc(3)/1.5,loc(4)/1.5];
	fig.Renderer='Painters';
	ax = gca;
	ax.BoxStyle = 'full';
	
	
	set(gca, 'XScale', 'log');
	set(gca, 'YScale', 'log');
	set(gca, 'ZScale', 'log');

	set(gca, 'XTick', 10.^(-3:3));
	set(gca, 'YTick', 10.^(-3:3));
	set(gca, 'ZTick', 10.^(-3:3));

	set(gca, 'XTickLabel',  num2str( get(gca,'XTick')' ,'%g'));
	set(gca, 'YTickLabel',  num2str( get(gca,'YTick')' ,'%g'));
	set(gca, 'ZTickLabel',  num2str( get(gca,'ZTick')' ,'%g'));
	
	box on;
	xlim(xminmax);
	ylim(yminmax);
	zlim(zminmax);
	axis square;
	
	hold on;
%%%
	for i = 1:numel(f);
		p = patch('Faces', f{i}, 'Vertices', v{i});       % draw the outside of the volume
		p.FaceAlpha = alpha(i);
		p.FaceColor = col{ci(i)};
		p.EdgeColor = 'none';
		% if ismember(i,[2,4,6]); reducepatch(p, 0.2); end;
	end
%%%
	xlabel( {'Relative conc. of'; targs{1} }  );
	ylabel( {'Relative conc. of'; targs{2} }  );
	zlabel( sprintf('Relative conc. of %s', targs{3})  );
%%%

	xlog_default_conc = 1;
	ylog_default_conc = 1;
	zlog_default_conc = 1;

	if ismember(1,standards)
		z = [zminmax(1), zminmax(1)];
		x = [1 1]*xlog_default_conc;
		y = [yminmax(1), yminmax(2)];
		plot3(x, y, z, 'k:');
		x = [xminmax(1), xminmax(2)];
		y = [1 1]*ylog_default_conc;
		plot3(x, y, z, 'k:');
	end
	if ismember(2,standards)
		z = [zminmax(2), zminmax(2)];
		x = [1 1]*xlog_default_conc;
		y = [yminmax(1), yminmax(2)];
		plot3(x, y, z, 'k:');
		x = [xminmax(1), xminmax(2)];
		y = [1 1]*ylog_default_conc;
		plot3(x, y, z, 'k:');
	end;
	if ismember(3,standards)
		x = [xminmax(1), xminmax(1)];
		y = [1 1]*ylog_default_conc;
		z = [zminmax(1), zminmax(2)];
		plot3(x, y, z, 'k:');
		y = [yminmax(1), yminmax(2)];
		z = [1 1]*zlog_default_conc; 
		plot3(x, y, z, 'k:');
	end;
	if ismember(4,standards)
		x = [xminmax(2), xminmax(2)];
		y = [1 1]*ylog_default_conc;
		z = [zminmax(1), zminmax(2)];
		plot3(x, y, z, 'k:');
		y = [yminmax(1), yminmax(2)];
		z = [1 1]*zlog_default_conc; 
		plot3(x, y, z, 'k:');
	end;
	if ismember(5,standards)
		y = [yminmax(1), yminmax(1)];
		z = [1 1]*zlog_default_conc;
		x = [xminmax(1), xminmax(2)];
		plot3(x, y, z, 'k:');
		z = [zminmax(1), zminmax(2)];
		x = [1 1]*xlog_default_conc;
		plot3(x, y, z, 'k:');
	end
	if ismember(6,standards)
		y = [yminmax(2), yminmax(2)];
		z = [1 1]*zlog_default_conc;
		x = [xminmax(1), xminmax(2)];
		plot3(x, y, z, 'k:');
		z = [zminmax(1), zminmax(2)];
		x = [1 1]*xlog_default_conc;
		plot3(x, y, z, 'k:');
	end;



%%%
end
%%%
