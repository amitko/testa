function res = logisticProbability(itemDifficultyLevels,th,o)
%Function
%logistic_probability(itemDifficultyLevels,itemDiscrimination,th,d,type)
%Calculates the logistic probability under the GRM.
%
% INPUT:
%   itemDifficultyLevels - row vector of values of the difficulty parameter
%                          for item grades.
%   itemDiscrimination   - Value of the item discrimination. Same for all
%                          grades.
%                    th  - value of the ability in the logit scale
%                    d   - value of the scaling parameter
%                          by default 1.702
%                  type  - thresholds (default value) ISRF / grades IGRF.
%                           

if nargin < 2
    error('Item parameters and ability levels required');
end;

if nargin < 3 | isempty(o)
    o = irT.grm.Options();
end;

type = o.thresholdsType;
d = o.D;

res = [];

for threshlold = itemDifficultyLevels
    val = exp(d * o.itemDiscrimination *(th - threshlold) )./( 1 + exp(d * o.itemDiscrimination *(th - threshlold) ));
    res = [res val];
end;

if strcmp(type, 'thresholds')
    return;
elseif strcmp(type, 'grades')
    t = res;
    res = [];
    res(1) = 1 - t(1);
    for k = 2:size(t,2)
        res = [res t(k-1) - t(k)];
    end;
    res = [res t(end)];
end;    