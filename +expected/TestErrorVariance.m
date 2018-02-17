function res=TestErrorVariance(par)
% Function res=expected.TestErrorVariance(par)
%	Returns the expected error variance
%	of a test calculated from the IRT
%	paramaters of the test items
%
%   INPUT:
%       par - parameters of the items with rows
%           [difficulty dicriminative gest]

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net

res = 0;
for p = par'
    res = res + irT.expected.ItemErrorVariance(p');
end;

