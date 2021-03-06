function res=ItemVariance(item_response)
% Function res=irT. cls.ItemVariance(item_response)
% calculates the population variance of the item score
%
% Input:
%   item_response - NxM matrix of dichotomous answers (0 or 1)
%                   from N subjects aver a set of M items
%
% Output:
%   res - vector of size 1xM of population variance for each item

% Dimitar Atanasov, i-Research, 2018
% datanasov@ir-statistics.net

p = irT.cls.ItemDifficulty( item_response );
res = p .* ( 1 - p );
