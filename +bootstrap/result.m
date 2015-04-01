function [est, std]=irt_bootstrap_result(par,pl)
% [est,std] = irt_bootstrap_result(par,pl)
% Returns a bootstrapped estimates of the
%         item characteristics parameters
% Input:
%     par - estimated values from the bootstrapped
%           samples (result of irt_bootstrap_estimate)
%     pl - if pl > 0 a distribution plot whit pl beans 
%           for each item is generated.
% Output:
%     est - matrix of estimated parameters of the items
%           each row is [difficulty dicriminative gest]
%     std - variance of the estimated parameters
%

% Dimitar Atanasov, 2008
% datanasov@nbu.bg

if nargin == 1
  pl = 0;
end;

est = [];
std = [];

for k = 1:size(par,2) % Items
  item = [];
  for l = 1:size(par,3); % Samples
    item = [item par(:,k,l)];
  end;

  est(k,:) = mean(item');
  std(k,:) = var(item');

 
  if pl > 0
    figure;
    subplot(3,1,1);
    hist(item(1,:),pl);
    title(['Item ' num2str(k) ' - Difficulty']);
    
    if size( item, 1) > 1
        subplot(3,1,2);
        hist(item(2,:),pl);
        title(['Item ' num2str(k) ' - Discrimination']);
    end;
    if size( item, 1) > 2
        subplot(3,1,3);
        hist(item(3,:),pl);
        title(['Item ' num2str(k) ' - Gest']);
    end;
  end;
  
end;
