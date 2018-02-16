function res = itemInformation(itemThresholds, itemDiscrimination, ability)

res = 0;
for threshold = itemThresholds
    res = res + irT.expected.itemInformation([threshold itemDiscrimination],ability);
end;


