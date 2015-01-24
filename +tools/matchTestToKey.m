function res=matchTestToKey(items, key)
%Function test_correct(items, key)
%   Returns the the correct answers for a given item
%
%   INPUT: 
%     items - examinies result
%     key   - row test key
%
%   OUTPUT:
%     Row of 1 for correct and 0 otherwise 

% Dimitar atanasov (2008)
% datanasov@nbu.bg

if size(key,1) > 1
  error('Wrong dimension of key');
end;

if size(items) ~= size(key)
  error('Dimensions of items and key must agree');
end;

res = zeros(size(items,1),size(items,2));
for l = 1:size(items,1)
	for k = 1:size(items,2)
      if items(l,k) == key(k)
        res(l,k) = 1;
      end;
	end;
end;
