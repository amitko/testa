function res=irtLogisticProbability(a,th,d)
% Function irtLogisticProbability(a,th)
%   returns the probability for IRT logistic model
%
%   INPUT:
%       a - parameters of the model
%           [difficulty dicriminative gest]
%       th - level of ability
%       d  - value of the scaling parameter
%           by default 1.702

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net


if nargin < 2
    error('Item parameters and ability levels required');
end;

if nargin < 3
    d = 1.702;
end;

if size(a,2) < 3
    a(3) = 0;
end;

if a(2) == 0
    a(2) = 1;
end;

res = a(3) + ( 1 - a(3)) ./ (1 + exp( d .*a(2) .* ( a(1) - th ) ));


