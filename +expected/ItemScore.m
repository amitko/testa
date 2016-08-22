function res = ItemScore(a,type)
% Function res = expected.ItemScore(a,type)
%
%   INPUT:
%       a    - parameters of the model
%           [difficulty dicriminative gest]
%       type - 'err' | 'appr'
%
%   OUTPUT:
%	the expected item score

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net


if nargin < 2
    type = 'erf';
end;

if size(a,2) > 1 && isempty( find( a(:,2) ) )
    a = a(1);
    a = [a 1];
end;


[nI,nP] = size(a);

if nP == 1
    a = [a ones(nI,1) zeros(nI,1)];
elseif nP == 2
    a = [a zeros(nI,1)];
elseif nP > 3
    error('Wrong input argument!');
end;


% if size(a,2) == 1
%     a = [a 1 0];
% elseif size(a,2) == 2
%     a = [a 0];
% elseif size(a,2) > 3
%     error('Wrong input argument!');
% end;

res = [];
for pp = a';
    pp = pp';
    X = (pp(1).*pp(2))./sqrt(2.*( 1 + pp(2).^2));

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
    res(end+1) = pp(3) + (1 - pp(3)) .* p;

end

res = res';
