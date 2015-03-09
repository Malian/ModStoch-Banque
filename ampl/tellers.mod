param alpha;
param beta;

set ind ordered ;
param time{ind};
param CA{ind}; # Cumulative arrivals

var s{t in ind}>=0;
var x{t in ind : t < last(ind)}>=0;
var c>=0;
minimize cost : alpha*c + beta * sum{t in ind:t<last(ind)} x[t];

s.t.

belowCurve{t in ind : t < last(ind)} :
s[t] <= CA[t];

RampUp{t in ind: t < last(ind)} :
s[t+1]-s[t] <= c *(time[t+1]-time[t]);

trapeze{t in ind:t<last(ind)}:
x[t]>= (CA[t]-s[t] + CA[next(t)] - s[next(t)])/2;

end;
