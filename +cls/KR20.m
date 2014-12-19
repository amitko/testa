function res= KR20(item_data,score)
% res= cls.KR20(item_data,score)
% 
%   Returns Kuder-Richardson coefficient of the
%   reliability of the test for the dichotomous
%   test results.
%
%   Input:
%       item_data - n by m matrix of 0 and 1 for
%           test results of n examinee ove m items.
%           1 for correct answer and 0 otherwise
%       score - n by 1 vector of examinees scores
%           if omitted it is calculated as sum of 
%           correct answers.
%
%   Output:
%       res = Kuder-Richardson coefficient

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net


if nargin < 2
    score = sum(item_data')';
end;

[n,k] = size(item_data);

if size( score, 2) ~= 1 || size( score, 1) ~= n
    error('Score should agree with th eitem data');
end;

p = [];

for c=1:k
    p(c) = size( item_data( item_data(:,c) == 1 ,c) , 1) / n;
end;
q = - (p - 1);

res = (k/(k-1)) *( 1 - (p*q')/var(score));
