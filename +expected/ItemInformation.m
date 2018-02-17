function res=ItemInformation(itemParameters,abilityValue,o)
%Function res = expected.ItemInformation(a,th)
%   Returns item information function
%
%   INPUT: 
%       itemParameters - item paramethers
%           [difficulty dicriminative gest]
%       abilityValue - ability value
%       
%       o - irt.Options
%
%   OUTPUT:
%       res(k) - Item information for ability th(k)

% Dimitar Atanasov 2016
% datanasov@ir-statistics.net

[nI,nP] = size(itemParameters);

if nP == 1
    itemParameters = [itemParameters ones(nI,1) zeros(nI,1)];
elseif nP == 2
    itemParameters = [itemParameters zeros(nI,1)];
elseif nP > 3
    error('Wrong input argument!');
end;

if nargin < 3
    o = irT.irt.Options;
end;

d = o.D;

res = [];

aO = ones(1,size(itemParameters(:,1),1))';
thO = ones(1,size(abilityValue,2));

p = irT.irt.LogisticProbability(itemParameters,abilityValue,d);
    
p(p > 1 - eps) = 1 - eps;

% 1.21 from van der Linden - Linear Models for Optimal Test Desigh.  

res = (itemParameters(:,2).^2 * thO) .* ( (1 - p) ./ p) .* ( ( p - itemParameters(:,3) * thO ) ./ (1 - (itemParameters(:,3) * thO)) ).^2;


