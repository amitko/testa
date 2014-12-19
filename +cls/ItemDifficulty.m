function res=ItemDifficulty(item_response)
% Function
% res=cls.ItemDifficulty(item_response)
% calculates the probability of the correct item performance
% intrepreted as difficulty in classical test theory.
%
% Input:
%   item_response - NxM matrix of dichotomous answers (0 or 1)
%                   from N subjects aver a set of M items
%
% Output: 
%   res - vector of size 1xM of proportions of the correct 
%         responces

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if ~isempty( find(item_response ~= 0 & item_response ~= 1, 1) )
    error('Wrong input matrix');
end;

res = sum( item_response )/size(item_response,1);