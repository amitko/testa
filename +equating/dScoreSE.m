function res = dScoreSE(parameters, theta)

expected_score = expected.ItemScore(parameters);
deltas = (ones(size(expected_score)) - expected_score)';

itemVar = irt.ItemVariance(parameters,theta);

res = sqrt( deltas.^2 * itemVar);