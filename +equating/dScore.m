function res = dScore(parameters,response)

% function res = dScore(parameters,response)
%
% Returns the so called d-Score for a person
% with a given response vector over a set
% of items with IRT parameters;

% Dimitar Atanasov, 2016
% datanasov@ir-statistics.net


expected_score = expected.ItemScore(parameters);

res = response*(ones(size(expected_score)) - expected_score);
