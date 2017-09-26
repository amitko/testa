function [params, CI, GF, Results] = logitDeltaFit(itemData,dScores,dScale,StartingPoint,model,type)

if nargin < 3 || isempty(dScale)
    dScale = [0:0.05:1]';
end;

if nargin < 4 || isempty(StartingPoint)
    StartingPoint = [1 0.5 0.1];
end;

if nargin < 5 || isempty(model) || model > 4 || model < 2
    model = 4;
end;    

if nargin < 6 || isempty(type)
    type = 'prop';
end;

Results.dScale = dScale;
Results.StartingPoint = StartingPoint;
Results.Model = model;
results.type = type;

Results.observedLogitDelta = scoring.observedLogitDelta(itemData,dScores,dScale);

if strcmp(type,'prop')
    x = dScale;
    to_fit = Results.observedLogitDelta;
elseif strcmp(type,'raw')
    x = dScores;
    to_fit = itemData;
else
    error('Unsupported type');
end;


%-----------------------------Fit the data---------------------------------
GF = {};
params = [];
CI = [];

Models = { '', ...
           '1-(1/(1+(x/B)^A))',...
           '1-((1-G)/(1+(x/B)^A))',...
           'U-((1-G)/(1+(x/B)^A))'
           };
Model_coefficients = {'A', 'B', 'G', 'U'};       

for y = to_fit

    Model_lb = [0.01 0.01 0.01 max(y) - 0.1];       
    Model_ub = [5    0.99 0.35 max(y) + 0.1];       
    start_point = [StartingPoint y(end)];
    
    fo_ = fitoptions('method','NonlinearLeastSquares',...
                     'Lower',Model_lb(1:model),...
                     'Upper',Model_ub(1:model));
    set(fo_,'Startpoint',start_point(1:model));

    ft_ = fittype(Models{model},...
         'dependent',{'y'},'independent',{'x'},...
         'coefficients',Model_coefficients(1:model));
     
     [cf, G] = fit(x,y,ft_,fo_);
     
     g.parameters = cf;
     g.fit = G;
     GF = [GF, {g} ];
     
     ci = confint(cf);
    
    if model == 2
        params = [params; [cf.A cf.B]];
         CI = [CI; [ci(1,1) ci(2,1) ci(1,2) ci(2,2)]];
    elseif model == 3
         params = [params; [cf.A cf.B cf.G]];
     CI = [CI; [ci(1,1) ci(2,1) ci(1,2) ci(2,2) ci(1,3) ci(2,3)]];
    elseif model == 4
         params = [params; [cf.A cf.B cf.G cf.U]];
     CI = [CI; [ci(1,1) ci(2,1) ci(1,2) ci(2,2) ci(1,3) ci(2,3), ci(1,4 ) ci(2,4)]];
    end;
       
end;