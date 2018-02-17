function res=ItemPerformance(item_parameters,th,o)
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

if nargin < 3 || isempty(o)
    o = irT.irt.Options;
end;

res = [];
if nargin < 2
    th = o.LatentTraitValues;
end;


%for k = 1:size(item_parameters,1)
%   res(k,:) = irT.irt.LogisticProbability(item_parameters(k,:),th);
%end;

warning('ItemPerformance: Out of date. Better to use irt.LogisticProbability directly');
res = irT.irt.LogisticProbability(item_parameters,th);

