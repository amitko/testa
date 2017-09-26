function h = logitDeltaPlot(GF,observedLogitDelta,dScale)

% GF output from logitDeltaFit

hold on;
h = plot(GF.parameters,'k-');
set(h, 'LineWidth',2)
plot(dScale,observedLogitDelta,'k-.', 'LineWidth',2);
xlabel('D-score');
ylabel('Probability for correct response');
legend('Fitted','Observed','Location','northwest');

hold off;
