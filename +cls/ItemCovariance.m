function res=ItemCovariance(item_response)
% Function res = irT.cls.ItemCovariance(item_response)
% calculates the covariance between the items
%
% Input:
%   item_response - NxM matrix of dichotomous answers (0 or 1)
%                   from N subjects aver a set of M items
%
% Output:
%   res - Matrix MxM of covariances

% Dimitar Atanasov, i-Research, 2018
% datanasov@ir-statistics.net

p = irT.cls.ItemDifficulty( item_response );
res=[];

for k=1:size(p,2)
    for j=1:size(p,2)
        p_jk = size( find(item_response(:,k) == 1 & item_response(:,j) == 1),1 )./size(item_response,2);
        res(k,j) = p_jk - p(j)*p(k);
    end;
end;
