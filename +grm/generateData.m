function res = generateData(itemThresholds,itemDiscriminations,abilityValues,o)

% abilityValues is a row

if nargin < 4
    o = irT.grm.Options();
end

d = o.D;

res = [];

for k = 1:size(itemThresholds,1)
    itemDifficultyLevels = itemThresholds(k,:);
    person = [];
    for ability = abilityValues
        probabilities = irT.grm.logisticProbability(itemDifficultyLevels,ability,o);
        
        pp = [1 probabilities 0];
        ppt = [];
        for l = 1 : size(pp,2)-1
            ppt(l) = pp(l) - pp(l+1) 
        end
        
        aaa =  mnrnd(1,ppt);
        person = [person; find(aaa == 1) - 1 ];
    end;
    res = [res person];
end;