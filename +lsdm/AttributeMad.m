function res = AttributeMad(item_performance, attribute_performance, Q, o)
% Function lsdm.AttributeMad(item_performance, attribute_performance, Q, o)
%   Calculates Mean Absolute Difference (MAD) between
%   true item performance and its attribute recovery.
%
% Input:
%   item_performance - n by m matrix of probabilities p(j,k)
%                       for correct answer  on item j from
%                       person with ability group k.
%   attribute_performance - p by m matrix of probabilities P(j,k)
%                       for possesing attribute j from person with
%                       ability group k.
%   Q                - matrix of indicators that item j
%                       requires attribute k  ( Q(j,k) = 1 ).
%   o                - lsdm.Options, uses LSDMModel
%
%   Output:
%       Mean Absolute Difference (MAD) for the set of attributes.

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net


[n,m] = size(item_performance);
[nA,mA] = size(attribute_performance);
[nQ,mQ] = size(Q);

if nargin < 4
    o = irT.lsdm.Options;
end;

if n ~= nQ || m ~= mA
    error('Dimension of item performance, attribute performance and Q should agree');
end;

if nA ~= mQ
    error('Dimension of attribute performance and Q should agree');
end;


pe = irT.lsdm.ItemRecovery( attribute_performance, Q, o);

err = abs( item_performance - pe);
res = mean(err');

