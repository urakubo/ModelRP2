

%%%
%%%
%%%
function table_params = SetParams(params, model);

	inum = size(params);
	s = {};
	for i = 1:inum(1);
		% fprintf('%s\n', params{i,1});
		s{i} = addparameter(model, cell2mat(params{i,1}), params{i,2});
	end;
	s  = transpose(s);
	table_params  = cell2table(s, 'VariableNames', {'Obj'});
	table_params.Properties.RowNames = params{:,1};

