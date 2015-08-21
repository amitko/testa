function [res, se] = dScore(parameters,response)

expected_score = expected.ItemScore(parameters);

res = response*(ones(size(expected_score)) - expected_score);
