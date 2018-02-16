function res = itemPerformance(itemDifficultyLevels,itemDiscrimination,th)
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


res = [];

for grade = 1:size(itemDifficultyLevels,2)
    for ability = 1:size(th,2)
        res(grade,ability) = irT.grm.logisticProbability(itemDifficultyLevels(grade), itemDiscrimination,th(ability));
    end;
end;