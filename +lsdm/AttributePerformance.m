function res=AttributePerformance(item_performance,Q,o)
% Function lsdm.AttributePerformance(item_performance,Q,model)
%   Returns the attribute performance for a given
%   set of item performance.
%
% Input:
%   item_performance - n by m matrix of probabilities p(j,k)
%                       for correct answer  on item j from
%                       person with ability group k.
%   Q                - matrix of indicators that item j
%                       requires attribute k  ( Q(j,k) = 1 ).
%   o                - lsdm.Options;
%   Output:
%       Attribute performance - p by m matrix of probabilities P(j,k)
%                       for possesing attribute j from person with
%                       ability group k.

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if nargin < 3
    o = irT.lsdm.Options;
end;

[n,m] = size(item_performance);
[nQ,mQ] = size(Q);

if n ~= nQ
    error('Dimimensions of the item performance and Q-matrix must agree');
end;

res = irT.lsdm.Generalised(item_performance,Q,o.LSDMModel);
