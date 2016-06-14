function res=LogisticProbability(itemParameters,abilityValue,d)
% Function irt.LogisticProbability(a,th)
%   returns the probability for IRT logistic model
%
%   INPUT:
%       itemParameters - parameters of the model
%                        [difficulty dicriminative gest]
%       abilityValue - level of ability
%       
%       d  - value of the scaling parameter
%           by default 1.702

% Dimitar Atanasov 2016
% datanasov@ir-statistics.net




if nargin < 2
    error('Item parameters and ability levels required');
end;

if nargin < 3
    d = 1.702;
end;


[nI,nP] = size(itemParameters);

if nP == 1
    itemParameters = [itemParameters ones(nI,1) zeros(nI,1)];
elseif nP == 2
    itemParameters = [itemParameters zeros(nI,1)];
elseif nP > 3
    error('Wrong input argument!');
end;


aO = ones(1,size(itemParameters(:,1),1))';
thO = ones(1,size(abilityValue,2));
 
res = (itemParameters(:,3) * thO) + ( 1 - itemParameters(:,3) * thO) ./ (1 + exp( d .* (itemParameters(:,2) * thO) .* ( itemParameters(:,1) * thO - aO * abilityValue ) ));


