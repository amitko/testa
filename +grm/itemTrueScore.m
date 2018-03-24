function res = itemTrueScore(itemThresholds, ability, scale_values, o, return_type)

if nargin < 5 || isempty(return_type)
    return_type = 'default';
end;

if nargin < 4 || isempty(o)
    o = irT.grm.Options();
end;

itemDiscrimination = o.itemDiscrimination;

if nargin < 3 || isempty(scale_values)
    scale_values = 1:size(itemThresholds,2);
end    

res = [];

for k = 1:size(ability,1)
    if strcmp(return_type,'default')
        itemPerformance = irT.grm.logisticProbability(itemThresholds, ability(k), o );
    else 
        itemPerformance = irT.grm.logisticProbability(itemThresholds, ability(k), o )';
    end;
    
    res(k,:) = (scale_values * itemPerformance') ./ sum(scale_values) * max(scale_values);
end