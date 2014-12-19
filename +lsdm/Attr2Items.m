function item_response=Attr2Items(attr_response,Q,o)
% Function item_response=lsdm.Attr2Items(attr_response,Q,o)
% 
% Returns dichotomous item response from given
% dichotomous attribute response and matrix Q for
% given type of cognitive model.
%
% Input: 
%   attr_response    - dichotomous attribute response
%   Q                - matrix of indicators that item j 
%                       requires attribute k  ( Q(j,k) = 1 ).
%   o                - lsdm.Options set LSDMModel 
%               Type of model: 
%               1 - {X=1} = \cap A_i
%               2 - {X=1} = \cup A_i
%               3 - {X=1} = \cup \bar A_i
%               4 - {X=1} = \cap \bar A_i

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if nargin < 3
    o = lsdm.Options;
end;

type = o.LSDMModel;

item_response = [];
for person = 1:size(attr_response,1)
    for q = 1:size(Q,1)
        if type == 1
            item_response(person,q) = all( attr_response(person,:) & Q(q, :));
        elseif type == 2   
            item_response(person,q) = any( attr_response(person,:) & Q(q, :));
        elseif type == 3
            item_response(person,q) = all( ~attr_response(person,:) & Q(q, :));
        elseif type == 4
            item_response(person,q) = any( ~attr_response(person,:) & Q(q, :));
        else
            error('Unsupported type');
        end;
        
    end;
end;
