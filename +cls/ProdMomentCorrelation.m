function res=ProdMomentCorrelation(item_response)
% Function
% res=cls.ProdMomentCorrelation(item_response))
% calculates the product moment correlation
% for a given set of items
%
% Input:
%   item_response - NxM matrix of dichotomous answers (0 or 1)
%                   from N subjects aver a set of M items
%
% Output:
%   res - Matrix MxM of coefficients

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

p = irT.cls.ItemDifficulty( item_response );
res=[];
for k = 1:size(p,2)
    for l = 1:size(p,2)
        res(k,l) = sqrt( ( p(k)*(1-p(l)) ) / ( p(l)*(1-p(k)) ) );
    end;
end;
