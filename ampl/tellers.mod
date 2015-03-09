param alpha;
param beta;

set ind ordered ;
set half_days;
set HD_AND_IND within {half_days,ind};
param time{ind};
param CA{half_days,ind}; # Cumulative arrivals

var s{hd in half_days,t in ind}>=0;
var x{hd in half_days,t in ind : t < last(ind)}>=0;
var c>=0;
minimize cost : alpha*c*card(half_days) + beta * sum{hd in half_days, t in ind:t<last(ind)} x[hd,t];
# We minimize the sum of the cost over all the half days
s.t.

belowCurve{hd in half_days, t in ind : t < last(ind)} :
s[hd,t] <= CA[hd,t];

RampUp{hd in half_days, t in ind: t < last(ind)} :
s[hd,t+1]-s[hd,t] <= c *(time[t+1]-time[t]);

trapeze{hd in half_days, t in ind:t<last(ind)}:
x[hd,t]>= (CA[hd,t]-s[hd,t] + CA[hd,next(t)] - s[hd,next(t)])/2;

end;
