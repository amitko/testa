function [pars,se]=ItemParametersEstimate_ML( response, theta, o)
% Function irt.ItemParametersEstimate_ML( response, theta,  o)
%   Returns the estimated parameters of the IRT model
%       for a set of items.
%
%   INPUT: 
%       response - observed examinee response
%                   ( 1 - correct, 0 - incorrect)
%       theta    - Latent trait values
%       o        - irt.Options
%
%   OUTPUT:
%       par - the values of the estimated parameters
%           [difficulty dicriminative gest]
%           1,2 or 3 parametric model, depending from 
%           the size of initial values a_0
%       se  - Standart error of the estimated parameters

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

    if nargin < 2 || isempty(theta)
        theta = zscore(sum(response'))';
    end;

    if nargin < 3
        o = irt.Options;
    end;

   
    if size(response,1) ~= size(theta,1)
        error('Responses and scores does not match');
    end;
    
    pars = [];
    se = [];
    for item = response
        p = irt_item_estimate( o.LatentTraitInterval , item, theta, o);
        pars = [pars;p];
        if nargout == 2
            lk=@(par)item_lklh(par,item,score,d);
            se=[se; sqrt(inv(hessian(lk,p)))];
        end;
        
    end;
    
% Additional functions    

function [par,se]=irt_item_estimate(th, item, theta, o )   
   a_0 = getfield(o, ['StartingPoint_' o.irtModels{ o.Model }]);
   if o.Model == 1
       dn = th(1);
       up = th(2);
   elseif o.Model == 2
       dn = [th(1) o.DicsriminationInterval(1)];
       up = [th(2) o.DicsriminationInterval(2)];
   else 
       dn = [th(1) o.DicsriminationInterval(1) o.GuessingInterval(1)];
       up = [th(2) o.DicsriminationInterval(2) o.GuessingInterval(2)];
   end;
   
   f = @(a_0)item_lklh(a_0,item,theta,o.D);
   par = fmincon(f, a_0, [], [], [], [], dn, up, [], o.OptimisationOptions);

function res=item_lklh(a,item_response,score,d)

    LP = @(a,s,d)irt.LogisticProbability(a,s,d);
    res = 0;
    for k=1:size(item_response,1)
        p = LP(a,score(k),d);
        if p < 1 - eps
            if  item_response(k)
                res = res - log(p);
            else
                res = res - log( 1 - p);
            end;
        end;
        if isnan(res)
          log(LP(a,score(k),d))  
          LP(a,score(k),d)
          pause
        end;
    end;