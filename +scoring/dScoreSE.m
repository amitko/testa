function res = dScoreSE(parameters, theta)

% Returns the so called d-Score SE for a person
% with a given a given ability theta (on a logit scale)
% over a set of items with IRT parameters;

% Dimitar Atanasov, 2016
% datanasov@ir-statistics.net

expected_score = expected.ItemScore(parameters);
deltas = (ones(size(expected_score)) - expected_score)';

itemVar = irt.ItemVariance(parameters,theta);
res = sqrt( deltas.^2 * itemVar);

