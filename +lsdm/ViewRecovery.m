function ViewRecovery(item_recovery,item_performance,o)
% Function lsdm.ViewRecovery(item_recovery,item_performance,o)
% Plots the ICC and Item Recovery Curve
%
%   Input:
%       item_recovery    - vector of LSDM item recovery
%       item_performance - vector of item performance
%       o                - lsdm.Options: use LatentTraitInterval and LSDMShowMad

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if nargin < 3
    o = irT.lsdm.Options;
end;

if size(item_recovery) ~= size(item_performance)
    error('Dimensions of item recovery and item performance does not match');
end;

th = linspace(o.LatentTraitInterval(1),o.LatentTraitInterval(2), size(item_recovery,2));

hold on;
plot(th, item_recovery,'d-k',th, item_performance,'-ok','LineWidth',1.5, 'MarkerSize', 8);
grid on;
xlabel('Ability (in logits)');
ylabel(['Probability' ]);
legend('LSDM recovery of ICC','ICC','Location','Best');

if strcmp(o.LSDMShowMad,'Yes')
    text(mean(th),0.05,['{\it MAD =}' sprintf('%3f',mad)],'Fontsize',12);
end;

for k = 1: size(th,2)
    plot([th(k), th(k)],[ item_recovery(k), item_performance(k)],'-k');
end;
hold off;
