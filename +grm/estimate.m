function thresholdValues = estimate(response, score, o)

    NofCategoies = max(unique(response))+1; % 0, 1, 2 ,3 ...
    
    if nargin < 2 || isempty(score) 
        score = zscore(sum(response'))';
    end

    
    if nargin < 3 || isempty(o)
        o = irT.grm.Options();
    end
    

    thresholdValuesStart = ones(1,NofCategoies - 1) .* o.thresholdValuesStart;
    thInterval = o.thInterval;
   

    if size(response,1) ~= size(score,1)
        error('Responses and scores does not match');
    end;
    
    
    thresholdValues = [];
    for item = response
        [thresholdValue]= grm_item_estimate(thInterval, item, thresholdValuesStart, score, o);
        thresholdValues = [thresholdValues; thresholdValue];
    end;
    
    
    
function  [thresholdValue] = grm_item_estimate(th, item, thresholdValuesStart, score, o)
%% GRM for a given item
    maxGrade = max(item);
    
    lb = th(1);
    ub = th(2);
        
    thresholdValue = [];
    SE = [];
    
    for grade = 1:maxGrade
        I = find( item >= grade);
        scored = zeros(size(score));
        scored(I) = 1; %ones(size(I));
        
        if abs(lb - ub) < 0.00001
            threshold = lb;
        else
            threshold = fit_values( scored,  score, lb, ub, o.itemDiscrimination, o.guessing(grade) , o.D);
        end;
        lb = threshold;
        thresholdValue = [thresholdValue threshold];
%        SE = [SE se];
    end;

 %%% Fit logistic curve
function res=fit_values(Performance, ability, lb, ub, b, c, d)
    %ft = fittype('c + ( ( 1 - c) ./ (1 + exp( 1.702 .*b .* ( a - x ) ) )) ','coefficients', {'a', 'b', 'c'} );
    ft = fittype('c + ( (1 - c) ./ (1 + exp( d .* b .* ( a - x ) ) ) )','coefficients', {'a'},'problem',{'b','c','d'} );
    fo = fitoptions(ft);
    fo.Lower = lb;
    fo.Upper = ub;
    fres = fit(ability, Performance , ft, fo, 'problem', {b, c, d});
    res=coeffvalues(fres);
    
    
    
