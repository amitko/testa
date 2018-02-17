function res=TestScoreReliability(par)
% Function expected.TestScoreReliability(par)
%	Returns the reliability of the test
%	score, calculted from IRT parameters
%	of the test items.
%
%   INPUT:
%       par - parameters of the items with rows
%           [difficulty dicriminative gest]

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

S = irT.expected.TestErrorVariance(par);
s = irT.expected.TestTrueScoreVariance(par);

res = s ./ ( s + S);
