function res=TestInformation(a,th)
% Function res = expected.TestInformation(a,th)
%   Returns test information for a given ability level
%
%   INPUT:
%       a( k , : ) - item paramethers for teh k-th item
%                   [difficulty dicriminative gest]
%       th - ability value
%
%   OUTPUT:
%       res(k) - Item information for ability th(k)

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

res = 0;

for it = a'
    info = expected.ItemInformation(it',th);
    if isfinite(info)
        res = res + info;
    else
        warning(['Item parameters are ' num2str(it') ', so the Item information is not finite']);
    end;
end;
