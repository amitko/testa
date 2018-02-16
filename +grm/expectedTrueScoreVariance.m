function res = expectedTrueScoreVariance(itemThresholds, itemDiscrimination, ability)
res = 0;

for p = 1:size(itemThresholds,1)
    for q = 1:size(itemThresholds,1)
        res = res + sqrt(irT.grm.itemExpectedTrueVariance(itemThresholds(p,:), itemDiscrimination, ability) .* ...
                         irT.grm.itemExpectedTrueVariance(itemThresholds(q,:), itemDiscrimination, ability) ...
                        );
    end;
end;
