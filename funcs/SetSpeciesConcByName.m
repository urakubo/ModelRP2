%
%
%
function species_obj = SetSpeciesConcByName(model, input_name, input_conc);

	%species_obj  = {};
	flag = 0;
	for i = 1:numel(model.Species);
		name = model.Species(i).Name;
		if strcmp(name, input_name)
			fprintf('SetSpeciesConcByName: %s found\n', input_name);
			model.Species(i).Value = input_conc;
			flag = 1;
		end
	end
	
	if (flag == 0)
		fprintf('SetSpeciesConcByName: %s unfound\n', input_name);
	end
