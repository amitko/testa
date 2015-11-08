function [pars,SE]=ItemParametersEstimate_EM_3PL( data,o)
%  Function [pars,ability] = irt.ItemParametersEstimate_EM_1PL( data,o)
%      estimates the parameters of the item characreristic
%      curves under the IRT model usen the EM algorith.
%
%  Input:
%      data - Dihotomous item response
%      o    - irt.Options (optional)
%  Output:
%      pars - Item parapeters

% Realizes according to the report for NCA
% Marginal Maximum Likelihood Estimation
% of Item Parameters: Illustration and
% Implementation

% Dimitar Atanasov - 2015
% datanasov@ir-statistics.net


if nargin < 2
    o = irt.Options;
end;

[N,J] = size(data);

% Read responses
if unique(data) ~= [0, 1]'
    error('Data should contain dichotomous item response without missing data');
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    params_0 = o.StartingPoint_3PL;
    m = o.NofLatentsCategories;

    % A_q
    quadratureNodes = o.LatentTraitValues;

    %w(A_q)
    quadratureWeights = pdf('norm',quadratureNodes,o.MeanOfLatentTrait,o.VarOfLatentTrait);

    if o.Model == 3
        log_prob = @(th,params_e,o) log_prob_3pl(th,params_e,o);
    elseif o.Model == 2
        log_prob = @(th,params_e,o) log_prob_2pl(th,params_e,o);
    else
        log_prob = @(th,params_e,o) log_prob_1pl(th,params_e,o);
    end;
    o.LogisticsModelFunctionReference = log_prob;

    % Initial item parameters
    xi_t = [];
    b = ones(1,J) * params_0(1);
    if o.StartingDifficultyEstimated == 1
        p_plus = sum(data) ./ size(data,1);
        p_star =  p_plus * 0.95 + 0.025;
        b = icdf('norm',1 - p_star,0,1);
    end;
    xi_t = b';
    xi_t = [xi_t, ones(J,1) * log(params_0(2)), ones(J,1) * params_0(3) ];

     iter = 1;
     fVal_old = -1;
o1 = o;

if ~isempty(o.EMAlgorithmStored)
    if exist(o.EMAlgorithmStored, 'file') == 2
        load(o.EMAlgorithmStored);
    end;
end;

o = o1;

while iter < o.NofIterations_EM
    %abs(fT_new - fT_old) > o.MaxFunTol && iter < o.NofIterations_EM

    disp(['Iteration of EM algorith ' num2str(iter)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E-step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('--- Calculating E step ...')
    P = zeros(m,N); % Conditional disttribution of latent categories

    if iter > 1
        xi_t = xi_new;
    end;
    
    % FIXME: Acceleration seems to work wrongly
    % Calculate new step values
%     if iter >= 2
%         xi_t1 = xi_t;
%         xi_t = xi_new;
%     elseif iter > 3
%         xi_t2 = xi_t1;
%         xi_t1 = xi_t;
%         xi_t = calculateNextParameters(xi_new,xi_t1,xi_t2);
%     end;
     xi_t = clearParameters(xi_t,o)


    % Equation 16
    EL = zeros(m,N); %Examinee likelihood
    disp('--- --- Calculating examinee likelihood ...')
    tic
    for k = 1:m % for latent categories
        for l = 1:N %for examinees
            EL(k,l) = examineeLikelihood(data(l,:),quadratureNodes(k),xi_t,o);
        end;
    end;
    toc

    disp('--- --- Calculating conditional disttribution of latent categories ...')
    tic

    %Equation 16
    for l = 1:N %for examinees
        denom = EL(:,l)' * quadratureWeights';
        for k = 1:m % for latent categories
            P(k,l) = ( EL(k,l) .* quadratureWeights(k) ) ./  denom;
        end;
    end;
    toc

    disp('--- --- Calculating expected values ...')
    tic
    % Equarion 15
    nq = zeros(1,m);
    for k = 1:m
        nq(k) = sum( P(k,:),2 );
        if isnan(nq(k))
            nq(k) = N .* quadratureWeights(k);  %0
        end;
    end;

    rk = zeros(J,m);
    for j = 1:J % Number of items
        for q = 1:m % for latent categories
            rk(j,q) = data(:,j)' * P(q,:)';
            if isnan(rk(j,q))
                rk(j,q) = 0;
            end;
        end;
    end;

    %Added to fit the distribution of the responses
    % FIXME: amitko is this should be done
    %quadratureWeights = nq./N;


    toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M-step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('--- Calculating M step ...')



    disp('--- --- Calculating weigths...');
    tic
    w = zeros(J,m);
    for j = 1:J
        for q = 1:m
            Pj = log_prob(quadratureNodes(q),xi_t(j,:),o);
            Ps = log_prob(quadratureNodes(q),[xi_t(j,[1,2]) 0],o);
            w(j,q) = (Ps .* (1 - Ps)) ./ (Pj .* (1 - Pj));
            if isnan(w(j,q)) || isinf(w(j,q))
                w(j,q) = 0.5;
            end;
        end
    end
    toc
    xi_new = zeros(J,3);
    fVal = zeros(J,3);
     for j = 1:J % for each item
         disp(['--- --- Estimate item ' num2str(j) '...'])
         tic
         F = @(x) linEqnForParamForItem(x,quadratureNodes,nq,rk(j,:),w(j,:),o);
         [xi_new(j,:), fVal(j,:)] = fsolve(F,xi_t(j,:),o.OptimisationOptions);
         toc
     end;
    %if max(sum(abs(fVal_old - fVal),2)) < o.MaxFunTol
    if  max(max(abs(xi_t - xi_new),2)) < o.MaxParTol
        disp(['Exit after ' num2str(iter) ' iterarions.'])
        break;
    end;

    disp(['Result after step ' num2str(iter) '...'] );

    fVal_old = fVal;

    iter = iter + 1;

    if ~isempty(o.EMAlgorithmStored)
        save(o.EMAlgorithmStored)
    end;


end; % while cicle

% prepare the autput
pars = [xi_t(:,1) exp(xi_t(:,2)) xi_t(:,3)];

if nargout == 1
    return;
end;

disp('Estimating SE ...');
% P(q,k) is the last one, calculted in E-step
% xi_t is the last one, calculated in M-step
% w(j,q) are the last one, calculated in M-step
SE = zeros(J,3);
parfor j = 1:J
    disp(['SE for item ' num2str(j)]);
    tic
    d2L = zeros(3,3);
    for k = 1:N
        S1 = 0;
        S2 = 0;
        S3 = 0;
        for q = 1:m
            PP = log_prob(quadratureNodes(q),xi_t(j,:),o);
            PPs = log_prob(quadratureNodes(q),[xi_t(j,[1,2]) 0],o);
            T =  P(q,k) .* (data(k,j) - PP);
            S1 = S1 + T .* w(j,q);
            S2 = S2 + T .* w(j,q) .* (quadratureNodes(q) - xi_t(1));
            S3 = S3 + T ./ PP .* ( 1 - PP) .* (1 - PPs);
        end;
        li_db = - o.D .* exp( xi_t(2) ) .* (1 - xi_t(3)) .* S1;
        li_dalpha = o.D .* exp( xi_t(2) ) .* (1 - xi_t(3)) .* S2;
        li_dc = S3;

        % Equation 42
        d2L = d2L + [li_db * li_db li_db * li_dalpha li_db * li_dc; li_dalpha * li_db li_dalpha * li_dalpha li_dalpha * li_dc; li_dc * li_db li_dc * li_dalpha li_dc * li_dc];
    end;
    % Equation 43
    d2g = [- 1 / o.priorDistributionParameters.alpha(2), 0, 0; 0, - 1 / o.priorDistributionParameters.b(2), 0; 0, 0, -(o.priorDistributionParameters.c(1) - 1)/xi_t(j,3)^2 - (o.priorDistributionParameters.c(2) - 1)/(1 - xi_t(j,3))^2 ];

    % Equation 28
    itemInf = d2L - d2g;

    SE(j,:) = sqrt(diag(inv(itemInf))');
    toc
end;


 %%%%%%%%%%%%%   Additional functions %%%%%%%%%%%%%%
 % Equation 3
 function res=examineeLikelihood(examineeResponse,th,pars_e,o)
 log_prob = o.LogisticsModelFunctionReference;
 P = log_prob(th,pars_e,o);
 I = examineeResponse == 1;
 II = examineeResponse == 0;
 pp = prod(P(I));
 pq = prod(1 - P(II));
 res = pp * pq;

 % Equation 1
 function res=log_prob_3pl(th,params_e,o)
     res = params_e(:,3) + ((1 - params_e(:,3)) .* exp( exp(params_e(:,2)) .* o.D .* ( th - params_e(:,1))) ./ (1 + exp( exp(params_e(:,2)) .* o.D .* ( th - params_e(:,1)))));

 function res=log_prob_2pl(th,params_e,o)
     res = exp( exp(params_e(:,2)) .* o.D .* ( th - params_e(:,1))) ./ (1 + exp( exp(params_e(:,2)) .* o.D .* ( th - params_e(:,1))));

 function res=log_prob_1pl(th,params_e,o)
     res = exp( exp(1) .* o.D .* ( th - params_e(:,1))) ./ (1 + exp( exp(1) .* o.D .* ( th - params_e(:,1))));

% Ecuation 35
function res = calculateNextParameters(xi,xi1,xi2)
    dxi = xi1 - xi;
    dxi1 = xi2-xi1;
    dxi2 = dxi1 - dxi;

    c = mnorm(dxi)/mnorm(dxi2);

    res = c*xi1 + (1-c)*xi2;

function  res=clearParameters(res,o)
    res( res(:,1) > o.LatentTraitInterval(2), 1 ) = o.LatentTraitInterval(2);
    res( res(:,1) < o.LatentTraitInterval(1), 1 ) = o.LatentTraitInterval(1);

    res( res(:,2) > 2, 2 )  = 2;
    res( res(:,2) < -1, 2 ) = -1;

    res( res(:,3) > 0.5, 3 ) = 0.5;
    res( res(:,3) < 0, 3 ) = 0.01;

% Equation 30
function res = linEqnForParamForItem(xi,quadratureNodes,n,r,w,o)
    log_prob = o.LogisticsModelFunctionReference;

    S1 = 0;
    S2 = 0;
    S3 = 0;
    for q = 1:size(quadratureNodes,2);
        P = log_prob( quadratureNodes(q),xi,o);
        PP = r(q) - (n(q) .* P);
        PP1 = PP .* w(q);
        % xi(2)
        S1 = S1 + ( PP1 .* (quadratureNodes(q) - xi(1)) );
        S2 = S2 + PP1;
        S3 = S3 + PP .* (1 / P );

    end;

    %FIXME without prior distr.

    res(1) = - o.D * exp(xi(2)) * ( 1 - xi(3)) * S2...
       - ((xi(1) - o.priorDistributionParameters.b(1))/ o.priorDistributionParameters.b(2));

    if o.Model > 1
        res(2) = o.D * exp(xi(2)) * ( 1 - xi(3)) * S1...
            - ((xi(2) - o.priorDistributionParameters.alpha(1))/ o.priorDistributionParameters.alpha(2));

    end;

    if o.Model > 2
        res(3) = (1/(1 - xi(3))) * S3...
            + ((o.priorDistributionParameters.c(1) - 1)/xi(3)) - ((o.priorDistributionParameters.c(1) - 1)/(1 - xi(3)));

    end;

% Norm for Equation 34
function res = mnorm(X)
    res = sqrt(sum(sum(X.^2)'));


