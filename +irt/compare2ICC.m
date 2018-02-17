function res = compare2ICC(pars1,pars2,o)

    if nargin < 3
        o = irT.irt.Options;
    end;

    th = linspace(o.LatentTraitInterval(1),o.LatentTraitInterval(2));

    v1 = irT.irt.LogisticProbability(pars1,th,o.D);
    v2 = irT.irt.LogisticProbability(pars2,th,o.D);

    res = max(abs( v1-v2 ));
