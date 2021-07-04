
function [ AC_basal, AC_dip, t_half ] = sim_2D(concs, targs, species, model, Toffset, varargin)

	%%
	names = get(model.Parameters, 'Name');
	id_DA_basal     = find( strcmp(names, 'DA_basal') );
	id_DA_dip       = find( strcmp(names, 'DA_dip'  ) );
	id_kon_AC_Golf  = find( strcmp(names, 'kon_AC_Golf')  );
	id_koff_AC_Golf = find( strcmp(names, 'koff_AC_Golf') );
	DA_basal     = model.Parameters(id_DA_basal);
	DA_dip       = model.Parameters(id_DA_dip);
	kon_AC_Golf  = model.Parameters(id_kon_AC_Golf);
	koff_AC_Golf = model.Parameters(id_koff_AC_Golf);
	%%
	if nargin == 7
		input_DA_basal = varargin{1};
		input_DA_dip   = varargin{2};

		DA_basal_backup = DA_basal.Value;
		DA_dip_backup   = DA_dip.Value;

		DA_basal.Value  = input_DA_basal;
		DA_dip.Value    = input_DA_dip;
	end
	%%
	reserv = {};
	for k = 1:2;
		if strcmp(targs{k}, 'tau_Golf')
			reserv{k} = [ kon_AC_Golf.Value, koff_AC_Golf.Value ];
		else
			reserv{k} = species{targs{k},'Obj'}.InitialAmount;
		end
	end
	%%

	nums = [numel(concs{1}), numel(concs{2})] ;
	t_half    = zeros( nums );
	AC_basal  = zeros( nums );
	AC_dip    = zeros( nums );
	targ_output = 'ACprimed';

	fprintf('Target1: %s \n', targs{1});
	fprintf('Target2: %s \n', targs{2});
	fprintf('\n');

	conc = [0,0];
	for i = 1:nums(1);
		conc(1) = concs{1}(i);
		for j = 1:nums(2);
			conc(2) = concs{2}(j);

			%% Param
			for k = 1:2;
				if strcmp(targs{k}, 'tau_Golf')
					kon_AC_Golf.Value  = reserv{k}(1) / conc(k);
					koff_AC_Golf.Value = reserv{k}(2) / conc(k);
				else
					species{targs{k},'Obj'}.InitialAmount = conc(k);
				end
			end

			%% Sim
			sd   = sbiosimulate(model);
			
			%% Time
			t_half(i,j) = obtain_half(targ_output, sd, Toffset);
			
			%% Steady
			AC1tot       = obtain_conc('AC1'      , sd, 0       );
			ACprimed     = obtain_conc(targ_output, sd, Toffset );
			ACprimed_end = sd.Data(end, find( strcmp( sd.DataNames, targ_output )) );

			AC_basal(i,j)  = ACprimed;
			AC_dip(i,j)    = ACprimed_end;
		end
	end

	%%
	%% Postprocessing
	%%

	%%
	for k = 1:2;
		if strcmp(targs{k}, 'tau_Golf')
			kon_AC_Golf.Value  = reserv{k}(1);
			koff_AC_Golf.Value = reserv{k}(2);
		else
			species{targs{k},'Obj'}.InitialAmount = reserv{k};
		end
	end
	%%
	if nargin == 7
		DA_basal.Value = DA_basal_backup;
		DA_dip.Value   = DA_dip_backup;
	end
	%%

end

