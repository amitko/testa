function [pars,ability]=irtItemParametersEstimate_EM_1PL( data, o )
%  Function [pars,ability]=irt_em_estimate( data,K,th)
%      estimates the parameters of the item characreristic
%      curves under the IRT model usen the EM algorith.
%
%  Input:
%      data - Dihotomous item response
%      o    - irtOptions
%
%  Output:
%      pars - Item parapeters
%      ability - proportions for different latent groups

% Dimitar Atanasov - 2014
% datanasov@ir-statistics.net

if nargin < 2
    o = irtOptions;
end;

[N,J] = size(data);

params_0 = o.StartingPoint_3PL;
m = o.NofLatentsCategories;
th_interval = o.LatentTraitInterval;

p = hist(irtAbilityGroups(sum(data')', m), m)./N;
th = th_interval(1):(th_interval(2) - th_interval(1))/(m-1):th_interval(2);


fT_new = 2;
fT_old = 0;


d = ones(J,1) * params_0;

iter = 1;
while abs(fT_new - fT_old) > 1 && iter < o.NofIterations_EM
 
   fT_old = fT_new;

 disp(['Begining of iteration ' num2str(iter) '. Function value ' num2str(fT_new)]);
 disp ('Parameters current value');
 disp(d);
 disp('Calculating E step');
 
    %  %%%%%%%%%%%  E step %%%%%%%%%%%%%%%
    ni=[];

    
    %%%% ==== calculating ni ====
    
    denom = []; % calculate denominator for e19, e20 for any individual
    for i = 1:N % number of individuals 
        denom(i) = e19_denom(data(i,:),th,d,p);
    end;
    
    e_17 = []; %calculate e17 for ani individual and ability category
    for k=1:m   % number of ability categories
        for i = 1:N % number of individuals (calculate e19)
           e_17(i,k) = e17(data(i,:),th(k),d); 
        end;
    end;
   
    for k=1:m   % number of ability categories
        T = [];
        for i = 1:N % number of individuals (calculate e19)
            T(i) = (p(k)*e_17(i,k) ) / denom(i);
        end;
    ni(k) = sum(T');
    end;

    r = [];
    % Calculating r
    for j=1:J
        for k=1:m
            T = [];
            for i=1:N % number of individuals (calculate e20)
                T(i) = ( data(i,j) * p(k) * e_17(i,k) )/( denom(i) );
            end;
        r(j,k) = sum(T);
        end;
    end;


    %  %%%%%%%%%%%%% M step %%%%%%%%%%%%%%%%
disp('Calculating M step');

    p = ni./N;

    f = @(d)log_lklh(d,r,ni,th,J,m);
    [dt,f_new] = fmincon(f, d , [], [], [], [], ones(J,1) * [th_interval(1) o.DiscriminationInterval(1)], ones(J,1) * [th_interval(2) o.DiscriminationInterval(2)], [],o.OptimisationOptions);
    d = dt;
    fT_new = f_new;    
    % = fminsearch(f,d);

iter = iter+1;
end;

pars = d;
ability = p;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res=log_prob(th,params)
res = 1 ./ (1 + exp( params(2)*1.702*(params(1) - th )));
%res = 1 ./ (1 + exp( params - th ));
%res = irtLogisticProbability(params,th);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = log_lklh(d,r,ni,th,J,m)

l_j = [];
    for j = 1:J
        dd = d(j,:);
        l_j(j) = 0;
        for k=1:m
              l_j(j) = l_j(j) + r(j,k)*log( log_prob(th(k),dd) ) + (ni(k) - r(j,k))*log( 1 - log_prob(th(k),dd) );
        end;

    end;
res = -sum(l_j');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = e17(y,th,pars)
res = 1;
for j = 1:size(y,2)
    if y(j) > 0
        res = res * log_prob(th,pars(j,:));
    else
        res = res * (1 - log_prob(th,pars(j,:)));
    end;

end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = e19_denom(y,th,pars,p)
res = 0;
for k =1:size(p,2)
    res = res + e17(y,th(k),pars)*p(k);
end;

