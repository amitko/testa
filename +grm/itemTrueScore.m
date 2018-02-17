function res = itemTrueScore(itemThresholds, ability, scale_values, o)

if nargin < 4 || isempty(o)
    o = irT.grm.Options();
end;

itemDiscrimination = o.itemDiscrimination;

if nargin < 3 || isempty(scale_values)
    scale_values = 1:size(itemThresholds,2);
end    

res = [];

for k = 1:size(ability,2)
    res(k,:) = (scale_values * irT.grm.logisticProbability(itemThresholds, ability(k), o )') / size(scale_values,2);
end