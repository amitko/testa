function res = itemTrueScore(itemThresholds, itemDiscrimination, ability, scale_values)



if nargin == 3 || isempty(scale_values)
    scale_values = 1:size(itemThresholds,2);
end    

res = [];

for k = 1:size(ability,2)
    res(k) = (scale_values * irT.grm.logistic_probability(itemThresholds, itemDiscrimination, ability(k) )') / size(scale_values,2);
end