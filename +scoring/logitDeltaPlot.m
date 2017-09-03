function [params, CI, GF] = logitDeltaPlot(GF,observedLogitDelta,dScale)

% GF output from logitDeltaFit

figure;
hold on;
plot(GF.parameters);
plot(dScale,observedLogitDelta);
legend('Fitted','Observed')

hold off;
