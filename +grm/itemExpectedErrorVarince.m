function res = itemExpectedErrorVarince(itemThresholds, o)

if nargin < 2 || isempty(o)
    o = irT.grm.Options();
end;

itemDiscrimination = o.itemDiscrimination;


r_ = [];

for b = itemThresholds
    r_ = [r_ irT.expected.ItemErrorVariance([b, itemDiscrimination])];
end

res = mean(r_);


