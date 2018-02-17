function res = plotItem(itemDifficultyLevels,o)
%Function
%
%plot_item(itemDifficultyLevels,itemDiscrimination,th,opt)
%
%Plot the ISRF of a given item under the GRM
%
% INPUT:
%   itemDifficultyLevels - row vector of values of the difficulty parameter
%                          for item grades.
%   itemDiscrimination   - Value of the item discrimination. Same for all
%                          grades.
%         th             - ability value on logit scale
%                           
%                    opt - option structure, 
%                           if opt.colour = 1 a colour set is used
%                           if opt.colour = 2 a black set is used
%                           if opt.legend = 1 a legend is shown		
%                       by default: 
%                           opt.legend = 0 - no legend;
%                           opt.colour  = 0 - default colour 'blue'
%                           opt.legend = 0;
%                           opt.colour  = 0;
%
% Uses functions from irt package.


% i-Research, 2012
% Dimitar Atanasov
% datanasov@ir-statistics.net

if nargin < 3 || isempty(o)
    o = irT.grm.Options();
end;

itemDiscrimination = o.itemDiscrimination;

opt = irT.irt.Options();

opt.legend = 0;
opt.colour  = 0;

opt.LatentTraitValues = o.LatentTraitValues;


item_performance = irT.grm.itemPerformance(itemDifficultyLevels,o);

irT.irt.PlotItemPerformance(item_performance,opt);
