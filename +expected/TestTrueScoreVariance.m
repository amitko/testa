function res = TestTrueScoreVariance(par)
%Function test_true_score_var_exp(par)
%	Retuns the expected true score variance
%	of the test from the IRT parameters of 
%	the test items
%   INPUT:
%       par - parameters of the items with rows 
%           [difficulty dicriminative gest]

% Dimitar Atanasov, 2008
% datanasov@nbu.bg

res = 0;
for P = par'
    for Q = par'
        p_i = expected.ItemScore(P');
        s_i = expected.ItemErrorVariance(P');
        p_j = expected.ItemScore(Q');
        s_j = expected.ItemErrorVariance(Q');

        if (p_i .* (1 - p_i) - s_i ) .* (p_j .* (1 - p_j) - s_j ) < 0
            continue
        end;
        res = res + sqrt( (p_i .* (1 - p_i) - s_i ) .* (p_j .* (1 - p_j) - s_j ) );
    end;
end;
