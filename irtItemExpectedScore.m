function res = irtItemExpectedScore(a,type)
% Function irt_item_score_expected(a)
%
%   INPUT:
%       a    - parameters of the model
%           [difficulty dicriminative gest]
%       type - 'err' | 'appr'
%
%   OUTPUT:
%	the expected item score

% Dimitar Atanasov (2008)
% datanasov@nbu.bg

if nargin < 2
    type = 'erf';
end;

if size(a,2) == 1
    a = [a 1 0];
elseif size(a,2) == 2
    a = [a 0];
elseif size(a,2) > 3
    error('Wrong input argument!');
end;

X = (a(1).*a(2))./sqrt(2.*( 1 + a(2).^2));

if strcmp(type,'erf')    
    p = ( 1 - erf(X) )./2;
elseif strcmp(type,'appr')
    erfX = 1 - (1 + 0.278393*abs(X) + 0.230389*abs(X).^2 + 0.000972*abs(X)^.3 + 0.078108*abs(X).^4)^-4;
    if X < 0
       erfX = -erfX;
    end;
    p = ( 1 - erfX )./2;
else
    p = 0;
end;
res = a(3) + (1 - a(3)) .* p;
