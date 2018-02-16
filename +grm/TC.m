function attributePerformanceForTargetedCompetence = TC(itemThresholds, itemDiscrimination, Q, targetedCompetence, th, type)
%Function
%
%grm_tc(itemThresholds, itemDiscrimination, Q, targetedCompetence, th,type)
%
%Calcultes the performance of the set of cognitive attributes under the GRM
%
% INPUT:
%   itemThresholds       - row vector of values of the difficulty parameter
%                          for item grades.
%   itemDiscrimination   - Value of the item discrimination. Same for all
%                          grades.
%               Q        - Q-matrix for the relation between items and 
%                          cognitive attributes   
%  targetedCompetence    - Targeted competence of the items
%         th             - ability value on logit scale
%       type             - if equal to 1 a ISRF is used.
%

% i-Research, 2012
% Dimitar Atanasov
% datanasov@ir-statistics.net




% Targered competence
% if type = 1 -> a grade greater than targeted

if nargin < 6 || isempty(type)
    type = 0;
end;

if size(itemThresholds,1) ~= size(targetedCompetence,1)
    error('Number of items and number of targetedCompetence values should match');
end;

for k = 1:size(itemThresholds,1)
    itemPerformance{k} = irT.grm.itemPerformance( itemThresholds(k,:), itemDiscrimination(k,1), th );
    gradePerformance{k} = irT.grm.gradePerformance(itemPerformance{k});
end;

itemPerformanceForTargetedCompetence = [];
for k = 1:size(targetedCompetence,1)
    if type > 0
        itemPerformanceForTargetedCompetence = ...
            [itemPerformanceForTargetedCompetence; itemPerformance{k}(targetedCompetence(k),:)];
    else
        itemPerformanceForTargetedCompetence = ...
            [itemPerformanceForTargetedCompetence; gradePerformance{k}(targetedCompetence(k),:)];
    
    end;
end;

attributePerformanceForTargetedCompetence = irT.lsdm.Estimate(itemPerformanceForTargetedCompetence, Q); % FIXME options