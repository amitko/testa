function [res] = abilityValuesEstimate_ML(response,params,trait_0,o)

% Function irt.abilityValuesEstimate_ML( response,params,trait_0,o)
%   Returns the estimated ability values according the IRT model
%       for a set of items with given parameters.
%
%   INPUT: 
%       response - observed examinee response
%                   ( 1 - correct, 0 - incorrect)
%       par - the values of the estimated parameters
%                  [difficulty dicriminative gest]
%       trait_0 - initional vector of ability values
%       o        - irt.Options
%
%   OUTPUT:
%       rev - the estimated ability values


% Dimitar Atanasov, 2015
% datanasov@ir-statistics.net


    if nargin < 4
        o = irt.Options;
    end;

   
    if size(response,2) ~= size(params,1)
        error('Responses and parameters does not match');
    end;


    for k = 1:size(response,1)
        res(k) = latent_value_estimate(response(k,:), params, trait_0(k), o);
    end;


%Additional functions



function [par,se]=latent_value_estimate(item_response, params,trait_0, o )   

   f = @(trait_0)latent_lklh(trait_0,item_response,params,o.D);
   par = fmincon(f, trait_0, [], [], [], [], o.LatentTraitInterval(1), o.LatentTraitInterval(2), [], o.OptimisationOptions);



function res=latent_lklh(trait,item_response,params,d)

    LP = @(params,trait,d)irt.LogisticProbability(params,trait,d);
    res = 0;
    for k=1:size(params,1)
        p = LP(params(k,:),trait,d);
        if p < 1 - eps
            if  item_response(k)
                res = res - log(p);
            else
                res = res - log( 1 - p);
            end;
        end;
        if isnan(res)
          log(LP(params(k,:),trait,d))  
          LP(params(k,:),trait,d)
          pause
        end;
    end;