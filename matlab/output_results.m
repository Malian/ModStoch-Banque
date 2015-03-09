% Script creating figures
%	!!! : CA and time must be in the workspace (see writedata.m)

close all
% Directories
data_dir = '../results/';
images_dir = '../report/images/';

% List all wanted files
served_files = dir([data_dir '*clients_served.csv']);

% Plot and save figures
for i = 1:length(served_files)
	served_files_name = served_files(i).name;
	served = csvread(strcat(data_dir,served_files_name),0,1);
	figure(i);
	plot(time,CA(i,:),'linewidth',2);hold on;
	plot(time,served,'linewidth',2,'Color','red');
	carac_str = strsplit(served_files_name,'clients_served.csv');
	carac_str = carac_str(1,1){1};
	title(carac_str);
	outputfig = strcat(images_dir,carac_str, 'clients_served.eps');
	print(i,outputfig, '-depsc');
end

c = csvread(strcat(data_dir,'half_day_opt_capacity.csv'))
fid = fopen('../report/tex_matlab/c_value.tex','w');
fprintf(fid,'$ %g $',c(1,1));
fclose(fid);

Nt = ceil(c(1,1)*mean_processing_time)
fid = fopen('../report/tex_matlab/tellers.tex','w');
fprintf(fid,'$ %g $',Nt);
fclose(fid);
