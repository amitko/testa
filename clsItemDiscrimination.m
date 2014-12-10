function res=clsItemDiscrimination(item_response)
% Function
% res=clsItemDiscrimination(item_response)
% calculates the discrimination index for a given set of items
%
% Input:
%   item_response - NxM matrix of dichotomous answers (0 or 1)
%                   from N subjects aver a set of M items
%
% Output:
%   res - vector with size M with discrimination indexes of the items

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if ~isempty( find(item_response ~= 0 & item_response ~= 1, 1) )
    error('Wrong input matrix');
end;

score = sum(item_response')';
[S,I] = sort(score);

d = round( size( I,1 )/3 );

res = sum(item_response(I(2*d:end),:)) ./ size( item_response(I(2*d:end),:), 1) - sum(item_response(I(1:d),:)) ./ size( item_response(I(1:d),:), 1);

