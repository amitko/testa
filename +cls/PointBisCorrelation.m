function res=PointBisCorrelation(item_response)
% Function
% res=cls.PointBisCorrelation(item_response)
% calculates the point biserial correlation
% for a given set of items
%
% Input:
%   item_response - NxM matrix of dichotomous answers (0 or 1)
%                   from N subjects aver a set of M items
%
% Output:
%   res - vector with size M with point biserial correlation
%         for the items set

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if ~isempty( find(item_response ~= 0 && item_response ~= 1, 1) )
    error('Wrong input matrix');
end;

score = sum(item_response')';
m = mean(score);
v = sqrt(var(score));

p = irT.cls.ItemDifficulty( item_response );

res = [];
for k = 1:size(item_response,2)
    I = item_response(:,k) == 1;
    res(k) = ( mean(score(I)) - m ) / v * sqrt( p(k) / normpdf(p(k)));

end;

