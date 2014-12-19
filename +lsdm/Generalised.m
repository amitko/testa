function res=Generalised(item_performance,Q,type)
% Function res=lsdm.Generalised(item_performance,Q,type)
%   Returns Generalized Least Distance Method estimate
%   for ability performance.
%
%   Inout:
%   item_performance - n by m matrix of probabilities p(j,k)
%                       for correct answer  on item j from 
%                       person with ability group k.%       
%   Q                - matrix of indicators that item j 
%                       requires attribute k  ( Q(j,k) = 1 ).
%   type             - Type of model: 
%               1 - {X=1} = \cap A_i
%               2 - {X=1} = \cup A_i
%               3 - {X=1} = \cup \bar A_i
%               4 - {X=1} = \cap \bar A_i
%               type can be column of different values for different
%               items

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

[m,n] = size( item_performance );
[mQ,nQ] = size(Q);

if nargin == 2
    type = 1;
end;

if m ~= mQ
    error('Dimension of item performance and Q-matrix must agree');
end;

if size(type,1) > 1 && size(type,2) == 1
    ab =[];
    for l = type'
        if l == 1
           ab = [ab [0 0]' ];
        elseif l == 2
            ab = [ab [1 1]' ];
        elseif l == 3
            ab = [ab [1 0]' ];
        elseif l == 4
            ab = [ab [0 1]' ];
        else
            error('Not supported type');
        end;
    end;
    type = ab';
end;

if size(type,1) == 1 && size(type,2) == 1

    res = lsdm(item_performance,Q,type);
    return;
    
elseif size(type,1) == 2 && size(type,2) == m   
    Res = [];
    
    for l = 1 : size( item_performance , 2 )
        k = item_performance(:,l);
        o=[];
        % o=optimset('Display','iter');
        T = lsqnonlin(@aim_glsdm,ones(size(Q,2),1).*(1/2),zeros(size(Q,2),1),ones(size(Q,2),1),o,k,Q,type(:,1)',type(:,2)');
        Res = [Res T];
    end;
    
    res = Res';
    return;
    
else
    error( 'Unsupported model');
end;
    



%%%%%%%%%%%%%%%%%%%%%
function res=aim_glsdm(T,P,Q,a,b)

R=[];

for k = 1:size(P,1)
    S = [];
    for l = 1:size(Q,2)
        S(l) = log(((1 - T(l)) .* b(k)) + ( T(l) .* (1 - b(k)) )) .* Q(k,l); 
    end;
    R(k) = (log(1 - P(k)) .* a(k)) + log(P(k)) .* (1 - a(k)) - sum(S);
end;

res = sum(R.^2);


