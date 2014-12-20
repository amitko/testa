function res = ItemScoreReliability(a)
% function res = expected.ItemScoreReliability(a)
%   INPUT:
%       a - parameters of the model
%           [difficulty dicriminative gest]
%   OUTPUT:
%	the reliability of the item score

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net

s = expected.ItemTrueVariance(a);

res = s ./ ( s + expected.ItemErrorVariance(a) );
