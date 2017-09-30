function res = trueScoreSE(itemDeltas, parameters, dScore, o)

if nargin < 4
    o = scoring.Options;
end;

if size(parameters,1) ~= size(itemDeltas,1)
    error('Item deltas and parameters does not match');
end;

n = size(parameters,1);
m = size(dScore,1);

P = scoring.PCR(parameters,dScore,o);

res = (sqrt(sum(((itemDeltas.^2 * ones(1,m))' .* (P .* (ones(m,n) - P) ))')) ./ sum(itemDeltas))';