function res = itemDelta(parameters)

% function res = itemDelta(parameters)
%
% Returns the so called delta value of an item
% with a given set id IRT parameters

% Dimitar Atanasov, 2016
% datanasov@ir-statistics.net

expected_score = expected.ItemScore(parameters);
res = ones(size(expected_score)) - expected_score;