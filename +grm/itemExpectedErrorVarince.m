function res = itemExpectedErrorVarince(itemThresholds, itemDiscrimination)

r_ = [];

for b = itemThresholds
    r_ = [r_ irT.expected.ItemErrorVariance([b, itemDiscrimination])];
end

res = mean(r_);


