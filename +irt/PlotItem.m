function res=PlotItem(par,o)
% Function irt.PlotItem(par,o)
%   Plots a items curve for item with IRT parameters par
%   for the ability value th
%
%   INPUT:
%       par - parameters of the items with rows 
%           [difficulty dicriminative gest]
%       o     - irt.Options 
%   OUTPUT:
%   	res - 1

% Dimitar Atanasov, 2016
% datanasov@ir-statistics.net


if nargin < 2 || isempty(o)
    o = irt.Options;
end;

th = o.LatentTraitValues;

item_performance = irT.irt.LogisticProbability(par,th);

res = irT.irt.PlotItemPerformance(item_performance,o);
