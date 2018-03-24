function res = itemExpectedErrorVarince(itemThresholds, o)

if nargin < 2 || isempty(o)
    o = irT.grm.Options();
end;

itemDiscrimination = o.itemDiscrimination;


r_ = [];

for b = itemThresholds
    r1_ = [];
    for b1 = b'
        r1_ = [r1_; irT.expected.ItemErrorVariance([b1, itemDiscrimination])];
    end;
    r_ = [r_ r1_];
end

res = mean(r_);


