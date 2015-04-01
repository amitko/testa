function par=irt_bootstrap_estimate( th, item_response, sample_size, samples, a_0, fit )
%Function irt_bootstrap_estimate( th, item_response, sample_size, samples, a_0, fit )
%   Returns the estimated parameters of the IRT model
%       for a given item over the bootstrapped sample.
%
%   INPUT: 
%       th - row vector of ability values
%       item_response - matrix N_by_M from N observations of responses of M items
%                     (0 - wrong, 1 - correct)
%       sample_size   - size of each bootstraped sample
%       samples       - numper of bootstraped samples
%       a_0 - initial values of the parameters
%
%   OUTPUT:
%       par(:,:, k) - the values of the estimated parameters
%                       [difficulty dicriminative gest]
%                       for the k-th bootstrapped sample

% Dimitar Atanasov - 2007
% datanasov@nbu.bg

if nargin < 6
    fit = 'fit';
end;

Sample = item_response_bootstrap(item_response, sample_size, samples);

par = [];
for k = 1:size( Sample, 3) % for each bootstrapped sample

display(['Processing sample ' num2str(k)] );

  for s = 1:size(Sample, 1)
    score(s) = test_score (Sample(s,:,k));
  end;

  ability = irt_ability_groups(score', size(th,2) );
  
  for l = 1:size( Sample, 2) % for each item
      obs_prop = irt_observed_proportions( Sample(:,l,k), ability);
      par(:,l,k) = irt_estimate(th, obs_prop, a_0, fit);
  end;
end;
