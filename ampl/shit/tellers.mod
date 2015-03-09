param alpha;
param beta;

set ind ordered ;
param time{ind};
param CA{ind}; # Cumulative arrivals

var x{t in ind:t<last(ind)}>=0;
var c>=0;
minimize cost : alpha*c + beta * sum{t in ind:t<last(ind)} x[t];

s.t.
trapeze{t in ind:t<last(ind)}:
x[t]>= (CA[t]-c*t + CA[next(t)] - c*next(t))/2;

end;
