
%%%
%%%
%%%
function InitAmount(name, amount, species, model);
	i = find(strcmp(species, name));
	model.Species(i).InitialAmount  = amount;


%%%
%%%
%%%
function PlotTargetResult(sd, tname);

	i = find( strcmp( sd.DataNames, tname ) );
	figure;
	plot(sd.Time, sd.Data(:,i));
	xlabel('Time');
	ylabel('State');
	title(tname);
	box off;
	set(gca,'TickDir','out');



%%%
%%%
%%%
function PlotAllResults(sd);

	figure;
	plot(sd.Time, sd.Data);
	xlabel('Time');
	ylabel('State');
	title('Simulation Results');
	box off;
	set(gca,'TickDir','out');
	legend(sd.DataNames);
	legend boxoff 


%%%
%%%
%%%
function PlotTargetResults(sd, tname);

	tid  = [];
	for i = 1:numel(tname);
		tmp = find( strcmp( sd.DataNames, tname{i} ) );
		tid  = [tid, tmp];
	end;
	figure;
	plot(sd.Time, sd.Data(:,tid));
	xlabel('Time');

	title('Simulation Results');
	box off;
	set(gca,'TickDir','out');
	legend(sd.DataNames(tid));
	legend boxoff 

