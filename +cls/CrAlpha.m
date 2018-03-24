function res=CrAlpha(item_response)
% Function res = irT.cls.CrAlpha(item_response)
% calculates the Cronbach's alpha coefficient
% for a given set of items
%
% Input:
%   item_response - NxM matrix of dichotomous answers (0 or 1)
%                   from N subjects aver a set of M items
%
% Output:
%   res - Cronbach's alpha coefficient

% Dimitar Atanasov, i-Research, 2018
% datanasov@ir-statistics.net

s = irT.cls.ItemVariance( item_response );
k = size(item_response,2);
v = var(sum(item_response'));

res = k/(k-1)*( 1 - ( sum(s)/v ) );
