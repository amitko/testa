function res=TestDependabilityIndex(th,par)
% Function res = expected.TestDependabilityIndex(th,par)
%   Returns the dependability index of the test for a given set 
%   of ability values th over a number of items with IRT parameters
% 
%   INPUT:
%       th  - vector of ability levels
%       par - parameters of the items with rows 
%           [difficulty dicriminative gest]
%
%   OUPUT: 
%       res - vector of dependability indexes

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net


n = size(par,1);
st = expected.TestTrueScoreVariance(par);
p_i = [];
for P = par'
    p_i = [p_i expected.ItemScore(P')];
end;
p = mean(p_i);
se = expected.TestErrorVariance(par);
sp = var(p_i);

res = [];
for t = th
    res = [res (( st + n.^2 .* (p - t).^2 ) ./ ( st +  n.^2 .* (p - t).^2 + se + n .* sp))];
end;
