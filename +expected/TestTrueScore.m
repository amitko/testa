function res = TestTrueScore(th, params)
% function res = expected.TestTrueScore(th, params)
% Returns a the test scores for the test
% with given set item parameters for the 
% given ability values
%
% INPUT:
%    th     - vector (row) of ability values
%    params - irt item parameters
%           [difficulty dicriminative gest]

% Dimitar Atanasov (2014)
% datanasov@ir-statistics.net

res = [];

for t = th
    r = 0;
    for p = params'
        r = r + irt.ItemPerformance(p',t);
    end;
    res = [res r];
end;

