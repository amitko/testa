function res = testInformation(itemsThresholds, itemsDiscrimination, th)
%Function
%
%grm_test_information(itemsThresholds, itemsDiscrimination, th)
%
%Calculates the test information function under the GRM.
%
% INPUT:
%         itemThresholds - matrix of values of the difficulty parameter
%                          for item grades. Each row represents an item.
%   itemDiscrimination   - Value of the item discrimination. Same for all
%                          grades.
%         th             - ability value on logit scale
%                           

% i-Research, 2012
% Dimitar Atanasov
% datanasov@ir-statistics.net

res = 0;
for k = 1:size(itemsThresholds,1)
    res = res + irT.grm.itemInformation( itemsThresholds(k,:), itemsDiscrimination, th);
end;