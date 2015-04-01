function res=item_response_bootstrap(item_response, sample_size, samples)
%Function item_response_bootstrap(item_response, sample_size, samples)
%
% Produces a bootstraped samples from the item_response matrix
%
% Input:
%     item_response - matrix N_by_M from N observations of responses of M items
%                     (0 - wrong, 1 - correct)
%     sample_size   - size of each bootstraped sample
%     samples       - numper of bootstraped samples
%
% Output
%     res - array (sample_size x M x samples)

% Dimitar Atanasov (2008)
% datanasov@nbu.bg

res = [];
for k = 1:samples
  for l = 1:sample_size
    res(l,:,k) = item_response ( random_choice ( size(item_response,1)  ), : );
  end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function k=random_choice ( n )
t = unifrnd(0,1,1,n);
[S,J] = sort(t);
k = J(1);
