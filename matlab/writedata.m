close all
clear all


%%
matlab_latex_dir = '../report/tex_matlab/';

%% Parameters (need them)
salary_half_day = 75; % In euros
tt = 3*60*60;
lambda = [0.0039399];
duration = [3*3600];
mean_processing_time = 173;

%% Computed parameters
alpha = salary_half_day/mean_processing_time;
beta = salary_half_day/tt;

%% Precision parameter
nSAMPLES = 1000;

%% Build points
% Start time for each period + end of last period
tstart = zeros(1,length(duration)+1);
for i = 2:length(duration)+1
	tstart(i) = tstart(i-1)+duration(i-1);
end
% Cumulative arrival according to the estimation of lambda
CA_points = zeros(1,length(duration)+1);
for i = 2:length(duration)+1
	CA_points(1,i) = CA_points(i-1)+duration(i-1)*lambda(i-1);
end
% Linear interpolation
time = linspace(0,tstart(end),nSAMPLES);
CA = interp1(tstart,CA_points,time);

%% Plot
plot(time,CA,'linewidth',2);

%% Produce files
% Write data in ampl readable format
ind = 1:length(time);
fid = fopen('../ampl/parameters.dat', 'wt');
fprintf(fid, 'param : ind : time CA :=');
fprintf(fid, '\n\t%g\t%g\t%g\t', [ind' time' CA'].' );
fprintf(fid, ';');
fclose(fid);

% parameters for a latex table
header = {'Half day salary(\euro )' 'Total half day time(s)' 'alpha(\euro $s$/clients)' 'beta(\euro/$s^2$'};
latex_table = [salary_half_day tt alpha beta];

latex_tab(strcat(matlab_latex_dir,'table_param.tex'), latex_table,header);


