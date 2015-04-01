function [res,q] = item_bootstrap (Data, Q, new_items, attr_distr, ability)
% Function item_bootstrap (Data, Q, new_items, attr_distr, ability)
%	Generates item responses over a set ot new items, bootstrapped 
%	from the attribute matrix Q. It is usefull if there are only few 
%	items observed.
%
%	Input:
%       	Data      - observed examinee response
%                          ( 1 - correct, 0 - incorrect)
%		Q         - the Q matrix for the set of cognitive atributes
%		new_items - number of new items to be benerated
%		attr_distr- row vector with probabilities of possesing the 
%				atributes for a given item. Default probability 
%				is 1/2.
%		ability   - if greater than 0, different ability are considered
%				
%
%	OUTPUT: 
%		res - result data set with new items attached to the original Data
%		q   - the attribute Q matrix for the new data set

% Dimitar Atanasov (2008)
% datanasov@nbu.bg

% CHECK
if size(Data,2) ~= size(Q,1)
  error('Dimensions of Data and Q matrix must agree!');
end;

if nargin == 3
  attr_distr = ones(1,size(Q,2)) .* 1/2;
end;

if nargin == 4
  ability = 0;
end;

res = Data;
q = Q;

atr = size(Q,2);
[n,m] = size(Data); % Number of persons and items

if ability > 0
 ability_lev = irt_ability_groups(Data,ability);
end;

% Calculate Attribute probalilities
p = [];

if ability == 0
	for k = 1:m
	    p(k) = - log ( sum ( Data(:,k) )/n );
	end;
else
  for a = distinct(ability_lev')
	for k = 1:m
	    p(k) = - log ( sum ( Data(find(ability_lev == a),k) )/n );
	end;
  end;
end;

if ability == 0
	attr_prob = - lsqnonneg (Q, p');

	% Create new items
	for k=1:new_items

	% generate random attribute sample
	  new_attr = random( 'bino', ones( size(attr_distr) ), attr_distr );
	  if isempty( new_attr(new_attr == 1) )
	      continue;
	  end;
	% probability for correct answer
	  prob_correct = prod( exp (attr_prob ( find( new_attr == 1) )) );

	%generate random response for the new item
	  item_response = random('bino', 1, prob_correct, size(Data,1) , 1);

	  res = [res item_response];
	  q = [q' new_attr']';
	  
	end;
else 
	error('Different abilities are not supported yet!!!');
end;
