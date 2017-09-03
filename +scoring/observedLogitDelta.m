function [res,dScale] = observedLogitDelta(ItemResponse, Dscore,dScale)

if nargin <= 2
    dScale = [0:0.05:1]';
end

res = [];

N = size(ItemResponse,1);

for d = dScale'
    I = find(Dscore <= d);
    R = [];
    for Item = ItemResponse
        R = [R sum(Item(I))/size(I,1)];
    end;
    res = [res; R];
end;