function res = Fit(abilityScale, attributePerformance)

res = [];

for k = 1:size(attributePerformance,1)
    ft = fittype('c + ( ( 1 - c) ./ (1 + exp( 1.702 .*b .* ( a - x ) ) )) ','coefficients', {'a', 'b', 'c'} );
    fres = fit(abilityScale', attributePerformance(k,:)' , ft);
    res = [res; coeffvalues(fres)];
end;