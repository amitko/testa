function f = itemPersonMap(itemD,studentsDScore,N_of_bins)

% function f = itemPersonMap(itemD,studentsDScore,N_of_bins)
%     Plots distribution of person's dScore and items deltas
%     on a common scale.
%     
%     default N_of_bins = 20

% Dimitar Atanasov, 2016
% datanasov@ir-statistics.net
    
    
    
    
if nargin == 2
    N_of_bins = 20;
end;

f = figure;
range = linspace(0,1,N_of_bins);
deltasCnt = (histc(itemD,range)./size(itemD,1)) * 100;
dScoreCnt = (histc(studentsDScore,range)/size(studentsDScore,1)) * 100;
bar(range,[deltasCnt dScoreCnt],'histc');
xlim([0 1]);
ylim([0 max([deltasCnt; dScoreCnt])]);
title('Item-Person Map');
ylabel('frequency (%)');
xlabel('Delta Scale');
legend('delta','d-Score');
