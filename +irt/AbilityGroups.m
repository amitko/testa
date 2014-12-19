function res=AbilityGroups(scores, n)
% Function res = irt.AbilityGroups(scores,n)
%   Returns column of ability groups for the examenee with scores
%
%   INPUT: 
%       scores - column of scores
%       n - number of groups
%
%   OUTPUT:
%       res - column of group for the examinee

% Dimitar Atanasov (2014)
% datanasov@ir-statistics.net

min_score = min(scores);
max_score = max(scores);

intervals = min_score : (max_score - min_score) ./ n : max_score;

res = zeros(size(scores,1),1);

for k = 1:size(intervals,2)-1
    I = find( scores >= intervals(k) & scores < intervals(k+1) );
    res(I) = ones(size(I,1),1) .* k;
end;
