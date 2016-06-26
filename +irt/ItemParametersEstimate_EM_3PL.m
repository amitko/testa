function [pars,SE]=ItemParametersEstimate_EM_3PL_t( data,o)
%  Function [pars,ability] = irt.ItemParametersEstimate_EM_3PL( data,o)
%      estimates the parameters of the item characreristic
%      curves under the IRT model usen the EM algorith.
%
%  Input:
%      data - Dihotomous item response
%      o    - irt.Options (optional)
%  Output:
%      pars - Item parapeters
%           [difficulty, discrimination, guessing]

% Realizes according to the report for NCA
% Marginal Maximum Likelihood Estimation
% of Item Parameters: Illustration and
% Implementation

% Dimitar Atanasov - 2015
% datanasov@ir-statistics.net


if nargin < 2
    o = irt.Options;
end;

if o.Model < 3 
    error('This function is prepared for 3PL model only')
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
    
    % Initial item parameters
    xi_t = [];
    b = ones(1,J) * params_0(1);
    if o.StartingDifficultyEstimated == 1
        p_plus = sum(data) ./ size(data,1);
        p_star =  p_plus * 0.95 + 0.025;
        b = icdf('norm',1 - p_star,0,1);
    end;
    xi_t = b';
    xi_t = [xi_t, ones(J,1) * log(params_0(2)), ones(J,1) * log( params_0(3) ./ (1 - params_0(3))) ];

     iter = 1;
     fVal_old = -1;
     
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

    % Acceleration of convergence
    if iter >= 2
        xi_t1 = xi_t;
        xi_t = xi_new;
    elseif iter > 3
        xi_t2 = xi_t1;
        xi_t1 = xi_t;
        xi_t = calculateNextParameters(xi_new,xi_t1,xi_t2);
    end;

    % Equation 16
    EL = zeros(m,N); %Examinee likelihood
    disp('--- --- Calculating examinee likelihood ...')
    
    itemProb = log_prob_3pl(quadratureNodes,xi_t,o);
    tic
    for l = 1:N
        zz = examineeLikelihood_1(data(l,:),itemProb);
        EL(:,l) = examineeLikelihood_1(data(l,:),itemProb);
        denom = EL(:,l)' * quadratureWeights';
        P(:,l) = ( EL(:,l) .* quadratureWeights' ) ./  denom;
    end;
    toc
    

    disp('--- --- Calculating expected values ...')
    tic
    % Equarion 15
    nq = zeros(1,m);
    for k = 1:m % for latent categories
        nq(k) = sum( P(k,:),2 );
        if isnan(nq(k))
            nq(k) = N .* quadratureWeights(k);
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
    toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M-step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('--- Calculating M step ...')



    disp('--- --- Calculating weigths...');
    tic
    w = zeros(J,m);
    Pj = log_prob_3pl(quadratureNodes,xi_t,o);
    Ps = log_prob_2pl(quadratureNodes,xi_t(:,[1,2]),o);
    w = (Ps .* (1 - Ps)) ./ (Pj .* (1 - Pj));
    w( isnan(w) | isinf(w) ) = 0.5;
    toc
 
    xi_new = zeros(J,3);
    fVal = zeros(J,3);
    parfor j = 1:J % for each item
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

% prepare the output
pars = [xi_t(:,1) exp(xi_t(:,2)) Psi(xi_t(:,3))];

if nargout < 2
    return;
end;

disp('Estimating SE ...');
% P(q,k) is the last one, calculted in E-step
% xi_t is the last one, calculated in M-step
% w(j,q) are the last one, calculated in M-step
SE = zeros(J,3);

PP = log_prob_3pl(quadratureNodes,xi_t,o);
PPs = log_prob_2pl(quadratureNodes,xi_t(:,[1,2]),o);

oP = ones(size(PP,2),1);

for j = 1:J % for each item
    disp(['SE for item ' num2str(j)]);
    tic
    d2L = zeros(3,3);    
    
     for k = 1:N % For each examinee
        T =  P(:,k) .* (data(k,j) * oP - PP(j,:)');
        S1 = sum(T .* w(j,:)' .* (quadratureNodes' - xi_t(j,1)));
        S2 = sum(T .* w(j,:)');
        S3 = sum((T ./ (PP(j,:)' .* ( 1 - PP(j,:)' )) .* (1 - PPs(j,:)')));

        li_db = - o.D .* exp( xi_t(j,2) ) .* (1 - Psi(xi_t(j,3))) .* S2;
        li_dalpha = o.D .* exp( xi_t(j,2) ) .* (1 - Psi(xi_t(j,3))) .* S1;
        li_dc = S3;

        % Equation 42
        d2L = d2L + [li_db * li_db li_db * li_dalpha li_db * li_dc;... 
                 li_dalpha * li_db li_dalpha * li_dalpha li_dalpha * li_dc; ...
                 li_dc * li_db li_dc * li_dalpha li_dc * li_dc];
     end;
    % Equation 43
    d2g = [ - 1 / o.priorDistributionParameters.b(2), 0, 0; ...
            0, - 1 / o.priorDistributionParameters.alpha(2), 0; ...
            0, 0, -(o.priorDistributionParameters.c(1) - 1)/Psi(xi_t(j,3))^2 - (o.priorDistributionParameters.c(2) - 1)/(1 - Psi(xi_t(j,3)))^2 ];

    % Equation 37
      itemInf = d2L - d2g;

    
    se = sqrt(diag(inv(itemInf))');
    if all(se > xi_t(j,:) * 0.1)
        SE(j,:) = [0 0 0];
        warning('SE is not estimated correctly!!!')
    else
        SE(j,:) = se;
   end;
    toc
end;


 %%%%%%%%%%%%%   Additional functions %%%%%%%%%%%%%%
 % Equation 3
 function res=examineeLikelihood(examineeResponse,th,pars_e,o)
 P = log_prob_3pl(th,pars_e,o);
 I = examineeResponse == 1;
 II = examineeResponse == 0;
 pp = prod(P(I));
 pq = prod(1 - P(II));
 res = pp * pq;

 function res=examineeLikelihood_1(examineeResponse,P)
 aa = examineeResponse' * ones(1,size(P,2));
 I = examineeResponse == 1;
 II = examineeResponse == 0;
 pp = aa .* P;
 pq = ( 1 - aa ) .* (1 - P);
 res = prod((pp.^aa) .* (pq).^ (1-aa));
 
 
 % Equation 1
function res=log_prob_3pl(th,params_e,o)
    aO = ones(1,size(params_e(:,1),1))';
    thO = ones(1,size(th,2));

    res = Psi(params_e(:,3) * thO) + (1 - Psi(params_e(:,3) * thO)) .* Psi(o.D .* exp(params_e(:,2) * thO) .* ( aO * th - params_e(:,1) * thO) );


     %   res = Psi(params_e(:,3)) + (1 - Psi(params_e(:,3))) .* Psi(o.D .* exp(params_e(:,2)) .* ( th - params_e(:,1)) );
 
 function res=log_prob_2pl(th,params_e,o)
    aO = ones(1,size(params_e(:,1),1))';
    thO = ones(1,size(th,2));
    res = Psi(o.D .* exp(params_e(:,2) * thO) .* ( aO * th - params_e(:,1) * thO) );
 
% Ecuation 35
function res = calculateNextParameters(xii,xii1,xii2)
    
    xi = [xii(:,1) exp(xii(:,2)) Psi(xii(:,3))];
    xi1 = [xii1(:,1) exp(xii1(:,2)) Psi(xii1(:,3))];
    xi2 = [xii2(:,1) exp(xii2(:,2)) Psi(xii2(:,3))];
    
    dxi = xi1 - xi;
    dxi1 = xi2-xi1;
    dxi2 = dxi1 - dxi;

    c = mnorm(dxi)/mnorm(dxi2);

    res = c*xi1 + (1-c)*xi2;
    
    res = [res(:,1) log(res(:,2)) log(res(:,3) ./ (1 - res(:,3)))];
    
% Equation 30
function res = linEqnForParamForItem(xi,quadratureNodes,n,r,w,o)
    %log_prob = o.LogisticsModelFunctionReference;

    S1 = 0;
    S2 = 0;
    S3 = 0;
    for q = 1:size(quadratureNodes,2);
        P = log_prob_3pl( quadratureNodes(q),xi,o);
        PP = r(q) - (n(q) .* P);
        PP1 = PP .* w(q);
        S1 = S1 + ( PP1 .* (quadratureNodes(q) - xi(1)) );
        S2 = S2 + PP1;
        S3 = S3 + PP .* (1 / P );

    end;

    res(1) = - o.D * exp(xi(2)) * ( 1 - Psi(xi(3))) * S2...
        - ((xi(1) - o.priorDistributionParameters.b(1))/ o.priorDistributionParameters.b(2));
    res(2) = o.D * exp(xi(2)) * ( 1 - Psi(xi(3))) * S1...
            - ((xi(2) - o.priorDistributionParameters.alpha(1))/ o.priorDistributionParameters.alpha(2));
    res(3) = (1/(1 - Psi(xi(3)))) * S3...
            + ((o.priorDistributionParameters.c(1) - 1)/Psi(xi(3))) - ((o.priorDistributionParameters.c(1) - 1)/(1 - Psi(xi(3))));

        
% Norm for Equation 34
function res = mnorm(X)
    res = sqrt(sum(sum(X.^2)'));

% Logistic function        
 function res = Psi(x)
    res = 1./(1 + exp(-x));

