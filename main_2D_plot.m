%%%%
%%%% Init
%%%%

	rmpath('./funcs');
	clear;

	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	check = 0;
%	check = 1;
	[model, species, params, Toffset] = msn_setup(check);
	% check == 0: normal; 
	% check != 1 AC1 binding do not affect Gi conc.

%%%
%%%

	fprintf('\n');
	targs = {'D2R','AC1','RGS'};


%	tmp = 10.^[-1:0.025:1];
	tmp = 10.^[-1:0.1:1];

	for i = 1:3;
		mult_concs{i}	= tmp;
		default_conc	= species{targs{i},'Obj'}.InitialAmount;
		concs{i}		= mult_concs{i} .* default_conc;
		fprintf('Standard conc %s: %g uM \n', targs{i}, default_conc );
	end


	T1_2  = 0.5;  %
	Io    = 0.75; %


%%
%% 2D plot 
%%
	dims = { [3,1], [2,1], [2,3] };
%	dims = { [3,1], [2,1] };
%	dims = { [3,1] };
%	dims = { [3,2] };

	for  i = 1:numel(dims);
		mult_conc = mult_concs(dims{i});
		mult_default_conc = {1, 1};
		conc = concs(dims{i});
		targ = targs(dims{i});

		[sd, i_simulation, t_half_simulation] = sim_2D(conc, targ, species, model, Toffset);
		T_HALF = (t_half_simulation < T1_2);
		INH    = (i_simulation > Io);
		ax = panel_plot(targ, mult_conc, T_HALF, INH, mult_default_conc, 'Simulation');

		mRGS = zeros(size(sd));
		mD2R = zeros(size(sd));
		mAC  = zeros(size(sd));
		for j = 1:size(sd, 1);
			for k = 1:size(sd, 2);
				mRGS(j,k)   = obtain_conc('RGS', sd{j,k}, 0);
				mD2R(j,k)   = obtain_conc('D2R', sd{j,k}, 0);
				mAC(j,k)    = obtain_conc('AC1', sd{j,k}, 0);
			end
		end

		[ i_theory, t_half_theory ] = theory(mD2R, mAC, mRGS, params);
		T_HALF = (t_half_simulation < T1_2);
		INH    = (i_simulation > Io);

		contour(ax, mult_conc{1}, mult_conc{2},  t_half_theory', [T1_2 T1_2],'r:','LineWidth',2);
		contour(ax, mult_conc{1}, mult_conc{2},  i_theory', [Io Io],'b:','LineWidth',2);

	end


%%%
%%% Functions
%%%

function ax = panel_plot(targs, mult_concs, T_HALF, INH, mult_default_conc, t_title )

	xconc = mult_concs{1};
	yconc = mult_concs{2};
	xminmax = [ min(xconc) , max(xconc) ];
	yminmax = [ min(yconc) , max(yconc) ];
	zminmax = [ 0, 1.0 ];
	x_default = mult_default_conc{1};
	y_default = mult_default_conc{2};

	ax = panel_prep3(xminmax, yminmax, zminmax, targs{1}, targs{2});
	
	title(ax,  t_title);
	mymap = [1 1 1;0 0 1;1 0 0];
	colormap(mymap);
	im1 = imagesc( ax, 'XData', xconc,'YData', yconc, 'CData', T_HALF', zminmax );
	im1.AlphaData = .3;

	mymap = [1 1 1;0 0 1;1 0 0];
	colormap(mymap);
	im2 = imagesc( ax, 'XData', xconc,'YData', yconc, 'CData', 0.5*INH', zminmax );
	im2.AlphaData = .3;

	plot(ax, xminmax, [y_default y_default], 'k:');
	plot(ax, [ x_default, x_default ], yminmax, 'k:');

end

