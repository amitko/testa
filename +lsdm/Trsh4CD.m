function [res, row] = Trsh4CD(cd_attributes,th)
% Function
%   [res, row] = lsdm.Trsh4CD(cd_attributes,th)

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net


if size(cd_attributes,2) ~= size(th,2)
    error('Dimension of the input parameters must agree');
end;

res = [];
for k = 1:size(cd_attributes,2)-1
    for l = 1:size(cd_attributes,1)
        I = find(cd_attributes(:,k) < cd_attributes(l,k));
        I1 = find(cd_attributes(I,k+1) > cd_attributes(l,k+1));
        if ~isempty(I1)
            [a1,b1] = irT.tools.find_line_pars([th(k) cd_attributes(l,k)],[th(k+1), cd_attributes(l,k+1)]);
            [a2,b2] = irT.tools.find_line_pars([th(k) cd_attributes(I(I1),k)],[th(k+1), cd_attributes(I(I1),k+1)]);
            x = -(( b1 - b2 )./( a1 - a2 ));
            res(l,I(I1)) = x;
        end;
    end;
end;
row = sort(res(find(res)));
