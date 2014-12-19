function res=StdCrAlpha(item_response)
% Function
% res=cls.StdCrAlpha(item_response)
% calculates the standartized Cronbach's alpha 
% coefficient for a given set of items
%
% Input:
%   item_response - NxM matrix of  answers from N
%                   subjects aver a set of M items
%
% Output: 
%   res - Standartized Cronbach's alpha coefficient

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net


N = size(item_response,2);
nu = mean(var( item_response ));
c = mean(mean(cov(item_response)));

res = (N*c) ./ (nu + (N-1).*c);