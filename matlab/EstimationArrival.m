function [nbr, lambda, delta, realTime] = EstimationArrival(x)

    if isempty(x)
        nbr = 0;
        lambda = 0;
        delta = 0;
        realTime = 0;
        return;
    end

    nbr      = nbserve(x);
    y        = x(~isnan(x));
    delta    = y(end) - y(1);
    realTime = deltaTimes(x);
    
    lambda = nbr/delta*3600;
    
    function k = nbserve(x)
        
        k   = 0;
        len = length(x);
        i   = 1;
        
        while i <= len
            if ~isnan(x(i))
                k = k + 1;
                i = i + 1;
            else
                j = lookNaN(x(i:end));
                i = i + j;
                k = k - 1;
            end
        end
    end

    function k = lookNaN(x)
        
        L = length(x);
        k = 1;
        
        while (k <= L && isnan(x(k)))
            k = k +1;
        end
        
        k = k - 1;
        
    end

    function timesVec = deltaTimes(x)
        timesVec = diff(x);
        timesVec = timesVec(~isnan(timesVec));
    end
    

end