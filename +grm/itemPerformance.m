function res = itemPerformance(itemDifficultyLevels,o)
%Function
%
%item_performance(itemDifficultyLevels,itemDiscrimination,th)
%
%Calculates the item performance (probabiloty for correct performance) under the GRM.
%
% INPUT:
%   itemDifficultyLevels - row vector of values of the difficulty parameter
%                          for item grades.
%   itemDiscrimination   - Value of the item discrimination. Same for all
%                          grades.
%         th             - ability value on logit scale
%                           

% i-Research, 2012
% Dimitar Atanasov
% datanasov@ir-statistics.net

if nargin < 2 || isempty(o)
    o = irT.grm.Options();
end;


th = o.LatentTraitValues;

res = [];

for grade = 1:size(itemDifficultyLevels,2)
    for ability = 1:size(th,2)
        res(grade,ability) = irT.grm.logisticProbability(itemDifficultyLevels(grade),th(ability),o);
    end;
end;