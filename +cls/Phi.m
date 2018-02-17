function res=Phi(item_response)
% Function
% res=cls.Phi(item_response)
% calculates the phi coefficient for a given set of items
%
% Input:
%   item_response - NxM matrix of dichotomous answers (0 or 1)
%                   from N subjects aver a set of M items
%
% Output:
%   res - Matrix MxM phi coefficients

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net


s = irT.cls.ItemVariance( item_response );
sc = irT.cls.ItemCovariance( item_response );

res=[];
for k = 1:size(s,2)
    for l = 1:size(s,2)
        res(k,l) = sc(k,l)/( s(l).*s(k) );
    end;
end;
