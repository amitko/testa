function res = itemExpectedTrueVariance(itemThresholds, ability, scale_values, o)

if nargin < 4 || isempty(o)
    o = irT.grm.Options();
end;

itemDiscrimination = o.itemDiscrimination;


if nargin < 3 || isempty(scale_values)
    scale_values = 1:size(itemThresholds,2);
end;    

res = irT.grm.itemTrueScore(itemThresholds,ability, scale_values.^2, o) - ... 
      irT.grm.itemTrueScore(itemThresholds, ability, scale_values, o).^2 - ... 
      irT.grm.itemExpectedErrorVarince(itemThresholds, o);