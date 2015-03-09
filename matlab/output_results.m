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
	plot(time,CA,'linewidth',2);hold on;
	plot(time,served,'linewidth',2,'Color','red');
	carac_str = strsplit(served_files_name,'clients_served.csv');
	carac_str = carac_str(1,1){1};
	outputfig = strcat(images_dir,carac_str, 'clients_served.eps');
	print(i,outputfig, '-depsc');
end
