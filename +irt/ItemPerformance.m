function res=ItemPerformance(th, item_parameters)
% Function res = expected.ItemPerformance(th, item_parameters)
%   returns prtformance of the set of items defined
%   by their IRT parameters
%
%   Input:
%       th - row vector of ability values
%       item_parameters - the values of the item parameters
%           each row represents one item
%           [difficulty dicriminative guest]
%
%   Output:
%       res = p by m matrix of probabilities P(j,k)
%               for correct answer on item j from 
%               person with ability group k.
    
%  Dimitar Atanasov, 2014
%  datanasov@ir-statistics.net

res = [];
for k = 1:size(item_parameters,1)
   res(k,:) = irt.LogisticProbability(item_parameters(k,:),th);
end;

