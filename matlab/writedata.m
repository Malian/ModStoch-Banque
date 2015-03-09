close all
clear all

% Parameters
salary_half_day = 75; % In euros
tt = 3*60*60;

% Precision parameter
nSAMPLES = 1000;

%% 1 - Estimation the arrival times
lambda = [0.02 0.05 0.02 0.015 0.01 0];
duration = [2000 2000 2000 2000 2000 1000];
mean_processing_time = 300;

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


plot(time,CA,'linewidth',2);

% Write data in ampl readable format
ind = 1:length(time);
fid = fopen('../ampl/parameters.dat', 'wt');
fprintf(fid, 'param : ind : time CA :=');
fprintf(fid, '\n\t%g\t%g\t%g\t', [ind' time' CA'].' );
fprintf(fid, ';');
fclose(fid);
