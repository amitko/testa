function res = HIndex(person_response, other_response)

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

[n_persons, n_items] = size(other_response);

if n_items ~= size(person_response,2)
    error('Person response is different then others');
end;

b_i = sum(person_response')/n_items;

nom = [];
denom = [];

for other = other_response'
    b_ij = sum(person_response'.*other)/n_items;
    b_j = sum(other)/n_items;
    nom = [nom b_ij-b_i*b_j];
    denom = [denom max([b_i*(1-b_j) b_j*(1-b_i)])];
end;

res = sum(nom')/sum(denom');
