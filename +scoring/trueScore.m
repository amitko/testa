function res = trueScore(itemDeltas, parameters, dScore, o)

if nargin < 4
    o = scoring.Options;
end;

if size(parameters,1) ~= size(itemDeltas,1)
    error('Item deltas and parameters does not match');
end;

n = size(parameters,1);
m = size(dScore,1);

P = scoring.PCR(parameters,dScore,o);

res = ( sum(((itemDeltas * ones(1,m))' .* P )') ./ sum(itemDeltas))';