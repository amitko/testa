function res = itemExpectedTrueVariance(itemThresholds, itemDiscrimination, ability, scale_values)

if nargin == 3 || isempty(scale_values)
    scale_values = 1:size(itemThresholds,2);
end;    

res = irT.grm.itemTrueScore(itemThresholds, itemDiscrimination, ability, scale_values.^2) - ... 
      irT.grm.itemSrueScore(itemThresholds, itemDiscrimination, ability, scale_values).^2 - ... 
      irT.grm.itemExpectedErrorVarince(itemThresholds, itemDiscrimination);