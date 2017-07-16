function [params, CI, GF] = logitDeltaFit(observedLogitDelta,dScale,st)

if nargin == 2
    st = [0 0.5 0.1];
end;

x = dScale;
%-----------------------------Fit the data---------------------------------
GF = {};
params = [];
CI = [];
for y = observedLogitDelta
    fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0.1 0.01 0.01 y(end) - 0.1],'Upper',[5 0.99 0.35 y(end) + 0.1]);
    set(fo_,'Startpoint',[st y(end)]);
    ft_ = fittype('U-(1-G)/(1+(x/B)^A)',...
         'dependent',{'y'},'independent',{'x'},...
         'coefficients',{'A', 'B', 'G', 'U'});
     [cf G] = fit(x,y,ft_,fo_);
     g.parameters = cf;
     g.fit = G;
     GF = [GF, {g} ];
     params = [params; [cf.A cf.B cf.G]];
     ci = confint(cf);
     CI = [CI; [ci(1,1) ci(2,1) ci(1,2) ci(2,2) ci(1,3) ci(2,3)]];
     hold on;
     plot(cf);
     plot(x,y);
     hold off;
end;