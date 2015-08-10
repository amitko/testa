function [trait ,pars,se] = estimate_JML( response, theta, o)

    if nargin < 2 || isempty(theta)
        theta = zscore(sum(response'))';
    end;

    if nargin < 3
        o = irt.Options;
    end;

    cond = 1;
    params_old = [];
    for k = 1:size(response,2)
        params_old(k,:) = getfield(o, ['StartingPoint_' o.irtModels{ o.Model }]);
    end;
    
    while  cond > 0.1
        [pars, se] = irt.ItemParametersEstimate_ML(response,theta,o);
        trait = irt.abilityValuesEstimate_ML(response,pars,theta,o);
        
        C = [];
        for k = 1:size(response,2)
            C(k) = irt.compare2ICC(pars(k,:),params_old(k,:));
        end;
        
        theta = trait;
        params_old = pars;
        
        cond = max(C);
    end;    
    