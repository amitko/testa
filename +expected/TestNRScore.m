function res=TestNRScore(par)
%Function expected.TestNRScore(par)
%	Returns expected NR score of a test
%	computed from the IRT paramaters of
%	the test items.
%
%   INPUT:
%       par - parameters of the items with rows
%           [difficulty dicriminative gest]

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net

res = 0;
for p = par'
   res = res + irT.expected.ItemScore(p');
end;
