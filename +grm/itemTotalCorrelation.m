function res=itemTotalCorrelation(item_response)
% Function
% res=grm_item_total_corr(item_response)
% calculates the item total correlation
% for a given set of polytomous items
%
% Input:
%   item_response - NxM matrix of polytomous answers 
%                   from N subjects aver a set of M items
%
% Output:
%   res - vector with size M with item total correlation
%         for the items set

% Dimitar Atanasov, 2013
% datanasov@nbu.bg

res = [];
for k = 1:size(item_response,2)

    score = sum(item_response(:,[1:k-1 k+1:end])')';
  
    res(k) = corr(item_response(:,k),score);
    
end;
