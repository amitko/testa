function res = ItemErrorVariance(a)
% Function res = expected.ItemErrorVariance(a)
%   INPUT:
%       a - parameters of the model
%           [difficulty dicriminative gest]
%	
%   OUTPUT:
%	item error variance, compuded from 
%	the IRT parameters

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net

if size(a,2) > 1 && isempty( find( a(:,2) ) )
    a = a(1);
    a = [a 1];
end;

if size(a,2) == 1
    a = [a 1 0];
elseif size(a,2) == 2
    a = [a 0];
elseif size(a,2) > 3
    error('Wrong input argument!');
end;

m = 0.2646 - 0.118 .* a(2) + 0.0187 .* a(2).^2;
d = 0.7427 + 0.7081 ./ a(2) + 0.0074 ./ a(2).^2;

s = m .* exp( - ((a(1)./d ).^2) ./2);
res = a(3) .* ( 1 - a(3) ) .* ( 1 - expected.ItemScore(a(1:2)) ) + (1 - a(3)) .* s;
