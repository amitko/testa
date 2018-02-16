function res = testInformationTC(itemsThresholds, itemsDiscrimination, targetedCompetence, ability)

res = 0;
for k = 1:size(itemsThresholds, 1)
    res = res + irT.grm.itemInformationTC(itemsThresholds(k,:), itemsDiscrimination(k), targetedCompetence(k), ability);
end