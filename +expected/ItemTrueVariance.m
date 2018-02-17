function res = ItemTrueVariance(a)
% Function res = expected.ItemTrueVariance(a)
%	Returns the expected true variance
%		computed from the IRT parameters of
%		a give item
%   INPUT:
%       a - parameters of the model
%           [difficulty dicriminative gest]

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net

p = irT.expected.ItemScore(a);

res = p .* ( 1 - p) - irT.expected.ItemErrorVariance(a);
