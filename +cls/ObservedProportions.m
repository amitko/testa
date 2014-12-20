function res = ObservedProportions(item_result, group)
% Function cls.ObservedProportions(item_result, group)
% Returns the observed proportions for each ability group on a given item
%
%   INPUT:
%       item_result - 1 if the answet is correct, 0 therwise
%       group - ability group 1,2,3,4,... etc.
%
%   OUTPUT:
%       res(k) = proportion of correct answers of the item for a group k

% Dimitar Atanasov 2014
% datanasov@ir-statistics.net

if size(item_result) ~= size(group)
    error('Dimensions of item_result and group must agree ')
end;

if size(item_result,2) ~= 1 | size(group) ~= 1
    error('Input arguments must be columns');
end;
   
if ~isempty ( item_result( find (item_result ~= 0 & item_result ~= 1 )))
    error('Wrong item results. Should be 0 or 1');
end;

res=[];
for k = distinct(group')
    if k < 1
        continue;
    end;
    I = find(group == k);
    res(k) = sum(item_result(I))/size(I,1);
end;
