function res=ItemInformation(a,th,o)
%Function res = expected.ItemInformation(a,th)
%   Returns item information function
%
%   INPUT: 
%       a - item paramethers
%           [difficulty dicriminative gest]
%       th - ability value
%
%   OUTPUT:
%       res(k) - Item information for ability th(k)

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net

if size(a,2) == 1
    a = [a 1 0];
elseif size(a,2) == 2
    a = [a 0];
elseif size(a,2) > 3
    error('Wrong input argument!');
end;

if nargin < 3
    o = irt.Options;
end;

d = o.D;

res = [];

if a(2) == 0
    a(2) = 1;
end;

for k = 1:size(th,2)

    p = irt.LogisticProbability(a,th(k));
    
    p1 = (a(2).*d.*exp(a(2).*d.*(a(1) - th(k))).*(a(3) - 1))/(exp(a(2).*d.*(a(1) - th(k))) + 1).^2;
    if p > 1 - eps
        p = 1 - eps;
    end
    res(k) = p1.^2 / (p.*(1-p));
end;
    
