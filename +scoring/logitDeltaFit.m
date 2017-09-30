function [params, CI, GF, Results] = logitDeltaFit(itemData,dScores,o);

if nargin < 3 || isempty(0) 
    o = scoring.Options;
end;

Results.dScale = o.dScale;
Results.StartingPoint = o.StartingPoint;
Results.Model = o.model;
Results.type = o.type;

Results.observedLogitDelta = scoring.observedLogitDelta(itemData,dScores,o);

if strcmp(o.type,'prop')
    x = o.dScale;
    to_fit = Results.observedLogitDelta;
elseif strcmp(o.type,'raw')
    x = dScores;
    to_fit = itemData;
else
    error('Unsupported type');
end;


%-----------------------------Fit the data---------------------------------
GF = {};
params = [];
CI = [];
for y = to_fit

    Model_lb = [o.param_lb max(y) - 0.1];       
    Model_ub = [o.param_ub max(y) + 0.1];       
    start_point = [o.StartingPoint y(end)];
    
    fo_ = fitoptions('method','NonlinearLeastSquares',...
                     'Lower',Model_lb(1:o.model),...
                     'Upper',Model_ub(1:o.model));
    set(fo_,'Startpoint',start_point(1:o.model));

    ft_ = fittype(o.Models{o.model},...
         'dependent',{'y'},'independent',{'x'},...
         'coefficients',o.Model_coefficients(1:o.model));
     
     [cf, G] = fit(x,y,ft_,fo_);
     
     g.parameters = cf;
     g.fit = G;
     GF = [GF, {g} ];
     
     ci = confint(cf);
    
    if o.model == 2
        params = [params; [cf.A cf.B]];
         CI = [CI; [ci(1,1) ci(2,1) ci(1,2) ci(2,2)]];
    elseif o.model == 3
         params = [params; [cf.A cf.B cf.G]];
     CI = [CI; [ci(1,1) ci(2,1) ci(1,2) ci(2,2) ci(1,3) ci(2,3)]];
    elseif o.model == 4
         params = [params; [cf.A cf.B cf.G cf.U]];
     CI = [CI; [ci(1,1) ci(2,1) ci(1,2) ci(2,2) ci(1,3) ci(2,3), ci(1,4 ) ci(2,4)]];
    end;
       
end;