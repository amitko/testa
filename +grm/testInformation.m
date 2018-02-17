function res = testInformation(itemsThresholds, o)

if nargin < 2 || isempty(o)
    o = irT.grm.Options();
end;


res = 0;
for k = 1:size(itemsThresholds,1)
    res = res + irT.grm.itemInformation( itemsThresholds(k,:), o.itemDiscrimination, o.LatentTraitValues);
end;