function res=GenerateData(N,p);
% Function res=cls.GenerateData(N,p)
%
% Simulate dichotomous item response from 
% N persons with probability for correct 
% performance p.
% 
%
% Input:
%       N - number of persons
%       p - vector of probabilities for correct
%           performance
% Output:
%      res - matrix of dichotomous item response
%            rows represent subjects response,
%            columns represent items.
%

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

%% -- Generate response as a binomial trials ---
res = [];
for p_ = p;
    res(:,end+1) = random('bino',1,p_, N,1);
end;
