close all
clear all


%%
matlab_data_dir = 'data/';
matlab_latex_dir = '../report/tex_matlab/';

%% Parameters (need them)
salary_half_day = 75; % In euros
tt = 3*60*60;

half_day_names = {'lundi_pm' 'mardi_pm' 'mercredi_am' 'mercredi_pm' 'vendredi_am'};
nHalfDays = 5;
lambda = csvread(strcat(matlab_data_dir,'lambdas.csv'));
duration = ones(5,3)*3600;
mean_processing_time = 173;

%% Computed parameters
alpha = salary_half_day/mean_processing_time;
beta = 1/20000*salary_half_day/tt;

%% Precision parameter
nSAMPLES = 1000;

%% Build points
% Start time for each period + end of last period
tstart = zeros(1,length(duration(1,:))+1);
for i = 2:length(duration(1,:))+1
	tstart(i) = tstart(i-1)+duration(i-1);
end
% Cumulative arrival according to the estimation of lambda
CA_points = zeros(length(lambda(:,1)),length(duration(1,:))+1);
for i = 2:length(duration(1,:))+1
	for hd = 1:length(lambda(:,1))
		CA_points(hd,i) = CA_points(hd,i-1)+duration(hd,i-1)*lambda(hd,i-1);
	end
end
% Linear interpolation
time = linspace(0,tstart(end),nSAMPLES);
CA = zeros(hd,nSAMPLES);
for hd = 1:nHalfDays
	CA(hd,:) = interp1(tstart,CA_points(hd,:),time);
	%% Plot
	plot(time,CA(hd,:),'linewidth',2);hold on;
end
legend('1','2','3','4','5');

%% Produce files
% Write data in ampl readable format
% - Cumulative arrivals
ind = 1:length(time);
fid = fopen('../ampl/parameters.dat', 'wt');
fprintf(fid, 'set half_days := lundi_pm mardi_pm mercredi_am mercredi_pm vendredi_am;\n');
fprintf(fid, 'param : ind : time :=');
for j = 1:nSAMPLES
	fprintf(fid, '\n%g\t%g\t', ind(j), time(j) );
end
fprintf(fid, ';\n');

fprintf(fid, 'param : HD_AND_IND : CA :=');
for hd = 1:nHalfDays
	for j = 1:nSAMPLES
		fprintf(fid, '\n%s\t%g\t%g\t', half_day_names{1,hd}, ind(j), CA(hd,j) );
	end
end
fprintf(fid, ';');
fclose(fid);

% parameters
fid = fopen('../ampl/coeff.dat','wt');
fprintf(fid, 'param alpha := %g;\n', alpha);
fprintf(fid, 'param beta := %g;\n', beta);
fclose(fid);

% parameters for a latex table
header = {'1/2 day salary(\euro )' 'Half day time(s)' '$\alpha$(\euro $s$/clients)' '$\beta$(\euro/clients$\cdot s$)'};
latex_table = [salary_half_day tt alpha beta];

latex_tab(strcat(matlab_latex_dir,'table_param.tex'), latex_table,header);




