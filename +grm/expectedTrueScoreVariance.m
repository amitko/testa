function res = expectedTrueScoreVariance(itemThresholds, ability, o)

if nargin < 3 || isempty(o)
    o = irT.grm.Options();
end;

itemDiscrimination = o.itemDiscrimination;



res = 0;

for p = 1:size(itemThresholds,1)
    for q = 1:size(itemThresholds,1)
        res = res + sqrt(irT.grm.itemExpectedTrueVariance(itemThresholds(p,:), ability,[], o) .* ...
                         irT.grm.itemExpectedTrueVariance(itemThresholds(q,:), ability, [] ,o) ...
                        );
    end;
end;
