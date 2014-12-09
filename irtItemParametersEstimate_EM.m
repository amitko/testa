function [pars,ability]=irtItemParametersEstimate_EM( data,m,th_interval, params_0 )
%  Function [pars,ability]=irt_em_estimate( data,K,th)
%      estimates the parameters of the item characreristic
%      curves under the IRT model usen the EM algorith.
%
%  Input:
%      data - Dihotomous item response
%      m    - Number of different latent clases
%      th   - [th_min th_max] values of the latent variable
%
%  Output:
%      pars - Item parapeters
%      ability - proportions for different latent groups

% Dimitar Atanasov - 2014
% datanasov@ir-statistics.net

[N,J] = size(data);

if nargin < 4
    params_0 = [0, 1, 0.1];
end;

p = hist(irtAbilityGroups(sum(data')', m), m)./N;
th = th_interval(1):(th_interval(2) - th_interval(1))/(m-1):th_interval(2);


fT_new = 1;
fT_old = 0;


d = ones(J,1) * params_0;

iter = 1;
while abs(fT_new - fT_old) > 0.01 & iter < 100
 
   fT_old = fT_new;

 disp(['Begining of iteration ' num2str(iter) '. Function value ' num2str(fT_new)]);
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
    
    Bmin = [];
    Bmax = [];

    for j = 1:J
        dd = d(j,:);
        f = @(dd)log_lklh(dd,r,ni,th,j,m);
        o = optimset('Display','iter');
        [dt,f_new] = fmincon(f, [0 1 0.1] , [], [], [], [], ones(J,1) * [th_interval(1) 0 0], ones(J,1) * [th_interval(2) 3 0.5], [],o)
        d(j,:) = dt;
        fT_new = fT_new + f_new;
    end;    
    
    d
    
    % = fminsearch(f,d);

iter = iter+1;
end;

pars = d;
ability = p;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res=log_prob(th,params)
%res = ( exp(  th - d  ) ) ./ (1 + exp( th - d ));
res = irtLogisticProbability(params,th);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = log_lklh(d,r,ni,th,j,m)

l_j = [];
for k=1:m
      l_j(k) = r(j,k)*log( log_prob(th(k),d) ) + (ni(k) - r(j,k))*log( 1 - log_prob(th(k),d) );
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

