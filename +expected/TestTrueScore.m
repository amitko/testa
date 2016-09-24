function res = TestTrueScore(params,th)
% function res = expected.TestTrueScore(th, params)
% Returns a the test scores for the test
% with given set item parameters for the 
% given ability values
%
% INPUT:
%    params - irt item parameters
%           [difficulty dicriminative gest]
%    th     - vector (row) of ability values

% Dimitar Atanasov (2014)
% datanasov@ir-statistics.net

res = sum(irt.LogisticProbability(params,th));

