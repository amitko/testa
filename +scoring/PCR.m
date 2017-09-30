function res = PCR(params,delta,o)

if nargin < 3
    o = scoring.Options;
end;

n = size(params,1); % N of items
m = size(delta,1); % N of persons

if o.model == 2
    res = ones(n,m) - ( ones(n,m) ./ ( ones(n,m) + (ones(n,1) * delta') ./ (params(:,2) * ones(1,m)) .^ (params(:,1) *  ones(1,m))));
elseif o.model == 3
    res = ones(n,m) - ( (ones(n,m) - params(:,3) * ones(1,m) ) ./ ( ones(n,m) + (ones(n,1) * delta') ./ (params(:,2) * ones(1,m)) .^ (params(:,1) *  ones(1,m))));
elseif o.model == 4
    res = params(:,4) * ones(1,m) - ( (ones(n,m) - params(:,3) * ones(1,m) ) ./ ( ones(n,m) + (ones(n,1) * delta') ./ (params(:,2) * ones(1,m)) .^ (params(:,1) *  ones(1,m))));
else
    error('Unsupported model!');
end;

res = res';

