function res = generateData(itemThresholds,itemDiscriminations,abilityValues,o)

if nargin < 4
    o = irT.grm.Options();
end

d = o.D;

res = [];

for k = 1:size(itemThresholds,1)
    itemDifficultyLevels = itemThresholds(k,:);
    itemDiscrimination = itemDiscriminations(k);
    person = [];
    for ability = abilityValues
        probabilities = irT.grm.logisticProbability(itemDifficultyLevels,itemDiscrimination,ability,d,'grades');
        person = [person; find(mnrnd(1,probabilities) == 1) - 1 ];
    end;
    res = [res person];
end;