close all;
clear all;

nbdatas = 5;
benchmark{6, nbdatas} = [];
benchmark(1, :) = {'lundi_pm', 'mardi_pm', 'mercredi_am', 'mercredi_pm', 'vendredi_am'};
realTimesAll = [];
nbrTotal = 0;

fprintf('-----------------------------------------------------------------------------------------------------------\n');
fprintf('---------------------------------------------- Data -------------------------------------------------------\n');
fprintf('-----------------------------------------------------------------------------------------------------------\n');
fprintf('\t \t \t \t %s \t\t %s \t\t %s \t\t %s \t\t %s\n', 'Nbr', 'Sec', 'H', 'mu', 'sigma');
fprintf('-----------------------------------------------------------------------------------------------------------\n');
for i = 1:nbdatas
    data = convertDataToTime(sprintf('data/%s.csv', benchmark{1, i}));
    [nbr1, lambda1, delta1, realTime1] = EstimationArrival(data(:, 1));
    [nbr2, lambda2, delta2, realTime2] = EstimationArrival(data(:, 3));
    
    benchmark{2, i} = nbr1 + nbr2;
    benchmark{3, i} = benchmark{2, i}/(3*3600);
    benchmark{4, i} = benchmark{3, i}*3600;
    
    nbrTotal = nbrTotal + benchmark{2, i};
    realTimesAll = [realTimesAll; realTime1; realTime2];
    
    params = lognfit([realTime1; realTime2]);
    mu = params(1);
    sigma = params(2);
    benchmark{5, i} = mu;
    benchmark{6, i} = sigma;
    
    fprintf('Estimation for %s : \t %g \t\t %g \t%g \t %g \t %g \n', benchmark{:, i});
end

values_nbr = cell2mat(benchmark(2, :));
values_lambda_sec = cell2mat(benchmark(3, :));
values_lambda_h = cell2mat(benchmark(4, :));
mus = cell2mat(benchmark(5, :));
sigmas = cell2mat(benchmark(6, :));

fprintf('-----------------------------------------------------------------------------------------------------------\n\n');
fprintf('-----------------------------------------------------------------------------------------------------------\n');

fprintf('mean : \t \t \t \t %g \t\t %g \t%g \t %g \t %g \n', mean(values_nbr), mean(values_lambda_sec), mean(values_lambda_h), mean(mus), mean(sigmas));
fprintf('median : \t \t \t %g \t\t %g \t%g \t %g \t %g \n', median(values_nbr), median(values_lambda_sec), median(values_lambda_h), median(mus), median(sigmas));
fprintf('std : \t \t \t \t %g \t %g \t%g \t %g \t %g \n', std(values_nbr), std(values_lambda_sec), std(values_lambda_h), std(mus), std(sigmas));

fprintf('-----------------------------------------------------------------------------------------------------------\n\n');

fprintf('-----------------------------------------------------------------------------------------------------------\n');
fprintf('---------------------------------------------- Log Normal -------------------------------------------------\n');
fprintf('-----------------------------------------------------------------------------------------------------------\n');

params = lognfit(realTimesAll);
fprintf('mu (normal) : \t \t %g\n', params(1));
fprintf('sigma (normal) : \t %g \n', params(2));
fprintf('mu (log-normal) : \t %g\n', exp(params(1))+params(2)^2/2);
fprintf('sigma (log-normal) : \t %g \n', sqrt((exp(params(2)^2)-1)*exp(2*params(1)+params(2)^2)));
fprintf('\n');

%% plot

x = 0:0.01:20*60;
y = lognpdf(x, mu, sigma);
z = logncdf(x, mu, sigma);

h = createFigure('Densit\''e de probabilit\''e', '$t(s)$', 'p');
grid on;
createPlot(h, x, y);

g = createFigure('Histogramme des temps au gichet', '$t(s)$', 'nombre de personnes');
hist(realTimesAll, 75);

