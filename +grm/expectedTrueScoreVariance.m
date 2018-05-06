function res = expectedTrueScoreVariance(itemThresholds, ability,scale_values, o)

if nargin < 4 || isempty(o)
    o = irT.grm.Options();
end;

res = 0;

for p = 1:size(scale_values,2)
    for q = 1:size(scale_values,2)
        a = irT.grm.itemExpectedTrueVariance(itemThresholds(:,p), ability,scale_values(:,p)', o);
        b = irT.grm.itemExpectedTrueVariance(itemThresholds(:,q), ability, scale_values(:,q)' ,o);
        rr = a .* b;
        res = res + sqrt( sum(rr,2) );
    end;
end;
