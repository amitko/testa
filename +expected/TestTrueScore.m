function res = TestTrueScore(params,th)
% function res = expected.TestTrueScore(params,th)
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

res = sum(irT.irt.LogisticProbability(params,th));

