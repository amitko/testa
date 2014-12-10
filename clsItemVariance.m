function res=clsItemVariance(item_response)
% Function
% res=clsItemVariance(item_response)
% calculates the pilulation variance of the item score
%
% Input:
%   item_response - NxM matrix of dichotomous answers (0 or 1)
%                   from N subjects aver a set of M items
%
% Output: 
%   res - vector of size 1xM of population variance for each item

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

p = clsItemDifficulty( item_response );
res = p .* ( 1 - p ); 