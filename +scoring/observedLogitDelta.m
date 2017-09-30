function [res,dScale] = observedLogitDelta(ItemResponse, Dscore,o)


if nargin < 3 || isempty(o)
    o = scoring.Options;
end

res = [];

N = size(ItemResponse,1);

d_prev = 0;
for d = o.dScale'
    I = find(Dscore <= d & Dscore > d_prev);
    R = [];
    for Item = ItemResponse
        prop = sum(Item(I))/size(I,1);
        if isnan(prop)
            R = [R 0];
        else    
            R = [R prop];
        end;
    end;
    res = [res; R];
    d_prev = d;
end;