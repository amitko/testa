function h = logitDeltaPlot(GF,observedLogitDelta,o)

% GF output from logitDeltaFit

if nargin < 3 || isempty(0)
    o = scoring.Options;
end;

hold on;
h = plot(GF.parameters,'k-');
set(h, 'LineWidth',2)
plot(o.dScale,observedLogitDelta,'k-.', 'LineWidth',2);
xlabel('D-score');
ylabel('Probability for correct response');
legend('Fitted','Observed','Location','northwest');

hold off;
