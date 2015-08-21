function res=ItemVariance(parameters, theta, o)
% Function
% res=irt.ItemVariance(item_response)
% calculates the pilulation variance of the item score
%

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if nargin < 3
    o = irt.Options;
end;

res=[];
for pp = parameters'
    pp = pp';
    p = irt.LogisticProbability(pp,theta,o.D);
    res(end+1) = p .* ( 1 - p ); 
end;

res = res';