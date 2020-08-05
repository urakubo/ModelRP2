%%
%%
%%
function [fig, ax] = plot_area_3D_3(T, A, targs, concs, default_conc, TITLE, standards)

	T = permute(T ,[2 1 3]);
	A = permute(A ,[2 1 3]);

	xlog_concs = log10(concs{1});
	ylog_concs = log10(concs{2});
	zlog_concs = log10(concs{3});

	xminmax = [ min(xlog_concs) , max(xlog_concs) ];
	yminmax = [ min(ylog_concs) , max(ylog_concs) ];
	zminmax = [ min(zlog_concs) , max(zlog_concs) ];

	t_not_inh =  T.*(1-A);
	inh_not_t =  A.*(1-T);
	both =  T.*A;

	f ={};
	v ={};
	[f{1},v{1}]    = isosurface(xlog_concs,ylog_concs,zlog_concs, t_not_inh, 0.5);
	[f{2},v{2},ic] = isocaps(xlog_concs,ylog_concs,zlog_concs, t_not_inh, 0.5);

	[f{3},v{3}]    = isosurface(xlog_concs,ylog_concs,zlog_concs, inh_not_t, 0.5);
	[f{4},v{4},ic] = isocaps(xlog_concs,ylog_concs,zlog_concs, inh_not_t, 0.5);

	[f{5},v{5}]    = isosurface(xlog_concs,ylog_concs,zlog_concs, both, 0.5);
	[f{6},v{6},ic] = isocaps(xlog_concs,ylog_concs,zlog_concs, both, 0.5);

	col = {'red','red','blue','blue','magenta','magenta'};

	fig = figure;
	loc = fig.Position;
	fig.Position = [loc(1),loc(2),loc(3)/1.5,loc(4)/1.5];
	fig.Renderer='Painters';
	ax = gca;
	ax.BoxStyle = 'full';
	box on;
	xlim(xminmax);
	ylim(yminmax);
	zlim(zminmax);
	axis square;
	alpha = 0.1;
	hold on;
%%%
	for i = 1:numel(f);
		p = patch('Faces', f{i}, 'Vertices', v{i});       % draw the outside of the volume
		p.FaceAlpha = alpha;
		p.FaceColor = col{i};
		p.EdgeColor = 'none';
		% if ismember(i,[2,4,6]); reducepatch(p, 0.2); end;
	end
%%%
	title(TITLE,'Interpreter','none')
	xlabel( sprintf('%s (10^X uM)', targs{1})  );
	ylabel( sprintf('%s (10^X uM)', targs{2})  );
	zlabel( sprintf('%s (10^X uM)', targs{3})  );
%%%

	xlog_default_conc = log10( default_conc{1} );
	ylog_default_conc = log10( default_conc{2} );
	zlog_default_conc = log10( default_conc{3} );

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
