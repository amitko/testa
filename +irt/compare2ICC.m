function res = compare2ICC(pars1,pars2,o)

    if nargin < 3
        o = irt.Options;
    end;

    th = linspace(o.LatentTraitInterval(1),o.LatentTraitInterval(2));
    
    v1 = irt.LogisticProbability(pars1,th,0.D);
    v2 = irt.LogisticProbability(pars2,th,0.D);
    
    res = max(abs( v1-v2 ));