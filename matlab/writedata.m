close all
clear all
lambda = [0.02 0.05 0.02 0.015 0.01 0];
duration = [2000 2000 2000 2000 2000 1000];
nSAMPLES = 1000;


tstart = zeros(1,length(duration)+1);
for i = 2:length(duration)+1
	tstart(i) = tstart(i-1)+duration(i-1);
end
CA_points = zeros(1,length(duration)+1);
for i = 2:length(duration)+1
	CA_points(1,i) = CA_points(i-1)+duration(i-1)*lambda(i-1);
end



time = linspace(0,tstart(end),nSAMPLES);
CA = interp1(tstart,CA_points,time);
ind = 1:length(time);



plot(time,CA,'linewidth',2);

fid = fopen('../ampl/parameters.dat', 'wt');
fprintf(fid, 'param : ind : time CA :=');
fprintf(fid, '\n\t%g\t%g\t%g\t', [ind' time' CA'].' );
fprintf(fid, ';');
fclose(fid);
