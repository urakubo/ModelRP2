%%
%%
%%
function save_tw_time_courses(sd, sd_noDAdip, sd_noCa, targs, data_dir, container);

	T_VGCC = container('Toffset_VGCC');
	Toffset_VGCC = T_VGCC.Value;


	for k = 1:numel(targs);
		time_courses ={};
		for i = 1: numel(sd);
			[T, DATA] = obtain_profile(targs{k}, sd{i}, Toffset_VGCC);
			time_courses{i} = [T, DATA];
		end
		save(sprintf('%s/time_courses_%s.mat',data_dir, targs{k}), 'time_courses');
		
		time_courses_noDAdip = obtain_profile(targs{k}, sd_noDAdip, Toffset_VGCC);
		save(sprintf('%s/time_courses_noDAdip_%s.mat',data_dir, targs{k}), 'time_courses_noDAdip');

		time_courses_noCa    = obtain_profile(targs{k}, sd_noCa, Toffset_VGCC);
		save(sprintf('%s/time_courses_noCa_%s.mat',data_dir, targs{k}), 'time_courses_noCa');
	end
end
