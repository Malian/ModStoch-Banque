close all;
clear all;

number_of_sample = 5;
benchmark{6, number_of_sample} = [];
benchmark(1, :) = {'lundi_pm', 'mardi_pm', 'mercredi_am', 'mercredi_pm', 'vendredi_am'};
realTimesAll = [];
nbrTotal = 0;

lamdas = zeros(number_of_sample, 3);

for i = 1:number_of_sample
    data = convertDataToTime(sprintf('data/%s.csv', benchmark{1, i}));
    
    
    data(data(:, 2) == 8, 2) = 9;
    data(data(:, 2) == 0, 2) = 1;
    
    if data(1, 2) == 9 || data(1, 2) == 10 && data(1, 2) == 11
        [nbr11, lambda11, delta11, realTime11] = EstimationArrival(data(data(:, 2) == 9, 1));
        [nbr12, lambda12, delta12, realTime12] = EstimationArrival(data(data(:, 2) == 10, 1));
        [nbr13, lambda13, delta13, realTime13] = EstimationArrival(data(data(:, 2) == 11, 1));
        
        [nbr21, lambda21, delta21, realTime21] = EstimationArrival(data(data(:, 4) == 9, 3));
        [nbr22, lambda22, delta22, realTime22] = EstimationArrival(data(data(:, 4) == 10, 3));
        [nbr23, lambda23, delta23, realTime23] = EstimationArrival(data(data(:, 4) == 11, 3));
    end
    
    if data(1, 2) == 1 || data(1, 2) == 2 || data(1, 2) == 3
        [nbr11, lambda11, delta11, realTime11] = EstimationArrival(data(data(:, 2) == 1, 1));
        [nbr12, lambda12, delta12, realTime12] = EstimationArrival(data(data(:, 2) == 2, 1));
        [nbr13, lambda13, delta13, realTime13] = EstimationArrival(data(data(:, 2) == 3, 1));
        
        [nbr21, lambda21, delta21, realTime21] = EstimationArrival(data(data(:, 4) == 1, 3));
        [nbr22, lambda22, delta22, realTime22] = EstimationArrival(data(data(:, 4) == 2, 3));
        [nbr23, lambda23, delta23, realTime23] = EstimationArrival(data(data(:, 4) == 3, 3));
    end
      
    nbr = nbr11 + nbr21;
    lambda = nbr/(delta11 + delta21);
    
    lamdas(i, :) = [(nbr11 + nbr21)/(3600)  (nbr12 + nbr22)/(3600)   (nbr13 + nbr23)/(3600)];
end

csvwrite('data/lambdas.csv', lamdas);
