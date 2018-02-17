function res = AttributeObservedPerformance(item_response, score, Q, o)
% Function res = lsdm.AttributeObservedPerformance(item_response, score, Q, o)
%   Calculates attribute performance for a given item responce
%
% Input:
%       item_responce - matrix n by m of item responces for set of m items.
%                   1 if the answet is correct, 0 therwise.
%       score         - vector-column of scores
%       Q             - matrix of indicators that item j
%                       requires attribute k  ( Q(j,k) = 1 ).
%       o             - lsdm.Options
%   Output:
%       Attribute performance - p by m matrix of probabilities P(j,k)
%                       for possesing attribute j from person with
%                       ability th(k).

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if nargin < 4
    o = irT.lsdm.Options;
end;

[n,m] = size( item_responce );
[nS,mS] = size( score );
[nQ,mQ] = size( Q );
[nT,mT] = size(th);


if n ~= nS || n ~= nQ
    error('Dimension of item response and score should agree');
end;

if m ~= nQ
    error('Dimensions of item responce and Q-matrix must agree');
end;

if mS ~= 1
    error('Score should be column');
end;

if nT ~= 1
    error('Ability levels shoul be vector');
end;

ability = irt.AbilityGroups(score', size(th,2) );

obs_prop = [];

for k = 1:size(item_response,2)
   obs_prop(k,:) = irT.cls.ObservedProportions(item_response(:,k),ability');
end;

res = irT.lsdm.AttributePerformance(obs_prop,Q,o);
