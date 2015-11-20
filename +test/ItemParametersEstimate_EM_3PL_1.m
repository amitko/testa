function [pars,ability]=ItemParametersEstimate_EM_3PL_1( data, o)
%  Function [pars,ability] = irt.ItemParametersEstimate_EM_1PL( data,o)
%      estimates the parameters of the item characreristic
%      curves under the IRT model usen the EM algorith.
%
%  Input:
%      data - Dihotomous item response
%      o    - irt.Options (optional) 
%  Output:
%      pars - Item parapeters
%      ability - proportions for different latent groups

% Dimitar Atanasov - 2014
% datanasov@ir-statistics.net

if nargin < 2
    o = irt.Options;
end;

[N,J] = size(data);

params_0 = o.StartingPoint_3PL;
m = o.NofLatentsCategories;
th_interval = o.LatentTraitInterval;

quadratureWeights = hist(irt.AbilityGroups(sum(data')', m), m)./N;
quadratureNodes = th_interval(1):(th_interval(2) - th_interval(1))/(m-1):th_interval(2);


fT_new = 2;
fT_old = 0;


d = ones(J,1) * params_0;

iter = 1;
while iter < o.NofIterations_EM
 
   fT_old = fT_new;

 disp(['Begining of iteration ' num2str(iter) ]);
 disp ('Parameters current value ');
 disp(d);
    %  %%%%%%%%%%%  E step %%%%%%%%%%%%%%%
    disp('--- Calculate E step ...')
    P = zeros(m,N); % Conditional disttribution of latent categories
    % Equation 16
    EL = zeros(m,N); %Examinee likelihood
    disp('--- --- Calculate examinee likelihood ...') 
    tic
    parfor k = 1:m % for latent categories
        for l = 1:N %for examinees
            EL(k,l) = examineeLikelihood(data(l,:),quadratureNodes(k),d,o); 
        end;
    end;
    toc

    disp('--- --- Calculate conditional disttribution of latent categories ...')
    tic
    %Equation 16
    for l = 1:N %for examinees
        for k = 1:m % for latent categories
            P(k,l) = ( EL(k,l) .* quadratureWeights(k) ) ./ sum( EL(:,l) .* quadratureWeights') ; 
        end;
    end;
    toc 

    disp('--- --- Calculate expected values ...')
    tic
    % Equarion 15
    nq = zeros(1,m);
    for k = 1:m
        nq(k) = sum( P(k,:)' );
    end;

    rk = zeros(N,m);
    for j = 1:J % Number of items
        for q = 1:m % for latent categories
            rk(j,q) = sum( data(:,j) .* P(q,:)' ); 
        end;
    end;
    toc

 
    
 
    %  %%%%%%%%%%%%% M step %%%%%%%%%%%%%%%%
disp('--- Calculate M step ...');

    dt = zeros(J,3);
    f_new = zeros(J,1);
    for j = 1:J
        disp(['Item ' num2str(j) '...'])
        tic
        f = @(p)log_lklh(p,rk(j,:),nq,quadratureNodes,m,o);
        [dt(j,:),f_new(j,:)] = fmincon(f, d(j,:) , [], [], [], [], ...
            [th_interval(1) o.DicsriminationInterval(1) o.GuessingInterval(1)], ...
            [th_interval(2) o.DicsriminationInterval(2) o.GuessingInterval(2)], ...
            [],o.OptimisationOptions);        
        toc
    end;

    % Exit condition
    if abs(fT_new - fT_old) > o.MaxFunTol
        break;
    end;
    
    fT_new = f_new;    
    d = dt;
    iter = iter+1;
end;

pars = d;
%ability = p;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = log_lklh(d,r,ni,th,m,o)
        l_j = 0;
        for k=1:m
              l_j = l_j + r(k)*log( log_prob(th(k),d,o) ) + (ni(k) - r(k))*log( 1 - log_prob(th(k),d,o) );
        end;
res = - l_j;




% Equation 3
 function res=examineeLikelihood(examineeResponse,th,pars_e,o)
 P = log_prob(th,pars_e,o);
 I = examineeResponse == 1;
 II = examineeResponse == 0;
 pp = prod(P(I));
 pq = prod(1 - P(II));
 res = pp * pq;
 
 % Equation 1
 function res=log_prob(th,params_e,o) 
     res = params_e(:,3) + ((1 - params_e(:,3)) ./ (1 + exp( params_e(:,2) .* o.D .* (params_e(:,1) - th ))));
 
