function res=ItemRecovery(attribute_performance, Q, o)
% Function lsdm.ItemRecovery(attribute_performance, Q, o)
%	Calculates probability for correcet item responce 
%	recovered from attribute performance.
%
% Input:
%   attribute_performance - p by m matrix of probabilities P(j,k)
%                       for possesing attribute j from person with 
%                       ability group k.
%   Q                - matrix of indicators that item j 
%                       requires attribute k  ( Q(j,k) = 1 ).
%   o                - lsdm.Options set LSDMModel 
%               Type of model: 
%               1 - {X=1} = \cap A_i
%               2 - {X=1} = \cup A_i
%               3 - {X=1} = \cup \bar A_i
%               4 - {X=1} = \cap \bar A_i
%
%   Output:
%       Probability for correcet item responce recovered from 
%           attribute performance

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if nargin < 3 
    o = lsdm.Options;
end;

model = o.LSDMModel;

if model == 1
    res=exp(Q * log(attribute_performance));
elseif model == 2
    res= 1 - exp(Q * log(ones( size(attribute_performance) ) - attribute_performance) );
elseif model == 3
    res = 1 - exp(Q * log(attribute_performance));
elseif model == 4
    res = exp( Q * log( ones( size(attribute_performance) ) - attribute_performance) );
end;    
