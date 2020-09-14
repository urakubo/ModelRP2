%%
%% Please run this program beforehand for "main_3D_plot.m"
%%


	clear;
	addpath('./model');
	addpath('./funcs');
	addpath('./funcs2');

	init_font;

	data_dir = 'data';
	TITLE = '3D';
	check = 0;
	[model, species, params, Toffset] = msn_setup(check);

%%%%
%%%% Simulation
%%%%

	FILENAME =  sprintf('%s/%s.mat', data_dir, TITLE);
	fprintf('\n');
	targs = {'RGS','AC1','D2R'};


	mult_concs = 10.^[-1:0.1:1];
	for i = 1:3;
		default_conc{i} = species{targs{i},'Obj'}.InitialAmount;
		concs{i} 		= mult_concs .* default_conc{i};
		fprintf('Original conc %s: %g uM \n', targs{i}, default_conc{i} );
	end


	nums = [numel(concs{1}), numel(concs{2}), numel(concs{3})] ;
	t_half_simulation = zeros( nums );
	i_simulation      = zeros( nums );
	initial_concs = {zeros(nums), zeros(nums), zeros(nums)};

	fprintf('\n');
	for i = 1:nums(1);
		fprintf('%s conc: %g uM \n', targs{1}, concs{1}(i));
		for j = 1:nums(2);
			% fprintf(' %s conc: %g uM \n', targs{2},  concs{2}(j));
			for k = 1:nums(3);
				species{targs{1},'Obj'}.InitialAmount = concs{1}(i) ;
				species{targs{2},'Obj'}.InitialAmount = concs{2}(j) ;
				species{targs{3},'Obj'}.InitialAmount = concs{3}(k) ;
				initial_concs{1}(i,j,k) = concs{1}(i);
				initial_concs{2}(i,j,k) = concs{2}(j);
				initial_concs{3}(i,j,k) = concs{3}(k);
				
				sd   = sbiosimulate(model);
				
				%% time
				t_half_simulation(i,j,k) = obtain_half('Gi_unbound_AC', sd, Toffset);
				
				%% Suppression
				AC1tot = obtain_conc('AC1', sd, 0);
				AC1GTP = obtain_conc('AC1_Gi_GTP', sd, Toffset);
				AC1GDP = obtain_conc('AC1_Gi_GDP', sd, Toffset);
				i_simulation(i,j,k) = ( AC1GTP + AC1GDP )./AC1tot;
			end
		end
	end
	save(FILENAME,'model','params','species','targs',...
		'mult_concs','default_conc','concs','nums', ...
		't_half_simulation','t_half_simulation','i_simulation',...
		'initial_concs');


%%
%% 2D plot 
%%

%{
	T1_2  = 0.5; % 0.5
	Io    = 0.75; %0.75; % 0.5

	T_HALF = (t_half_simulation < T1_2);
	AMP_B  = (i_simulation      > Io);

	dims = [2,1];
	panel_plot2(dims, targs, concs, T_HALF, AMP_B, default_conc)

	dims = [1,3];
	panel_plot2(dims, targs, concs, T_HALF, AMP_B, default_conc)

	dims = [2,3];
	panel_plot2(dims, targs, concs, T_HALF, AMP_B, default_conc)


function panel_plot2(dims, targs, concs, TAU_R, AMP_B, default_conc)

	tdim = setdiff([1,2,3], dims);

	TAU_R = permute(TAU_R , [dims(2) dims(1) tdim] );
	AMP_B = permute(AMP_B , [dims(2) dims(1) tdim] );
	tid = nearest_id(concs{tdim}, default_conc{tdim});
	TAU_R = squeeze( TAU_R(:,:,tid) );
	AMP_B = squeeze( AMP_B(:,:,tid) );

	xlog_concs = log10(concs{dims(1)});
	ylog_concs = log10(concs{dims(2)});
	xminmax = [ min(xlog_concs) , max(xlog_concs) ];
	yminmax = [ min(ylog_concs) , max(ylog_concs) ];
	zminmax = [ 0, 1.0 ];
	x_default_conc = default_conc{dims(1)};
	y_default_conc = default_conc{dims(2)};

	ax31 = panel_prep(xminmax, yminmax, zminmax, targs{dims(1)}, targs{dims(2)});
	mymap = [1 1 1;0 0 1;1 0 0];
	colormap(mymap);
	im1 = imagesc( ax31, 'XData', xlog_concs,'YData', ylog_concs, 'CData', TAU_R, zminmax );
	im1.AlphaData = .5;

	mymap = [1 1 1;0 0 1;1 0 0];
	colormap(mymap);
	im2 = imagesc( ax31, 'XData', xlog_concs,'YData', ylog_concs, 'CData', 0.5*AMP_B, zminmax );
	im2.AlphaData = .5;

	plot(ax31, xminmax, [log10(y_default_conc) log10(y_default_conc)], 'k--');
	plot(ax31, [ log10(x_default_conc), log10(x_default_conc) ], yminmax, 'k--');
end

%}

