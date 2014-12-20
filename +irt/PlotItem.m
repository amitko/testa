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

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net


if nargin <2 
    o = irt.Options;
end;

th = o.LatentTraitValues;

for item = 1:size(par,1)
    for ability = 1:size(th,2)
        item_performance(item,ability) = irt.LogisticProbability(par(item,:),th(ability));
    end;
end;

o.

res = irt.PlotItemPerformance(item_performance,o);
