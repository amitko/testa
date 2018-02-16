function res = itemInformationTC(itemThresholds, itemDiscrimination, targetedCompetence, ability)
%Function
%
%grm_item_information_for_tc(itemThresholds, itemDiscrimination,targetedCompetence, ability)
%
%Calculates the item information function for targeted competence.
%
% INPUT:
%         itemThresholds - row vector of values of the difficulty parameter
%                          for item grades.
%   itemDiscrimination   - Value of the item discrimination. Same for all
%                          grades.
%   targetedCompetence   - row vector required targeted competence.
%         ability        - ability value on logit scale
%                           

% i-Research, 2012
% Dimitar Atanasov
% datanasov@ir-statistics.net

    stepPerformance = irT.grm.itemPerformance(itemThresholds, itemDiscrimination, ability);
    gradePerformance = irT.grm.gradePerformance(stepPerformance);
    
    prob =  gradePerformance( targetedCompetence + 1)
    res = (itemDiscrimination .^2) *( prob / (1 -prob));