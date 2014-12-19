function [res, row] = Levels4CD(cd_values,o)
% Function
%   [res, row] = lsdm.Levels4CD(cd_values,o)
%   Calculates intersection points between
%   probabilistic curves defined in cd_values
%   (for example calculated with lsdmAttr4CD)
%   or values of reaching a certain level.
%
%   Inputs:
%       cd_values - probalistic curves
%       o         - lsdm.Options, uses LatentTraitInterval and LSDMReachedLevel and LSDMLevels 
%
%   Returns:
%       res  - intersection points
%       row  - values of th where level is reached
%
%   Uses a linear interpolation.
%

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net

if nargin == 1
    o = lsdm.Options;
end;



if size(cd_values,2) ~= size(th,2)
    error('Dimension of the input parameters must agree');
end;

if strcmp(o.LSDMLevels,'No')
%% Intersection points of curves defined in rows of cd_values
    res = [];
    for k = 1:size(cd_values,2)-1
        for l = 1:size(cd_values,1)
            I = find(cd_values(:,k) < cd_values(l,k));
            I1 = find(cd_values(I,k+1) > cd_values(l,k+1));
            if ~isempty(I1)
                [a1,b1] = tools.find_line_pars([th(k) cd_values(l,k)],[th(k+1), cd_values(l,k+1)]);
                [a2,b2] = tools.find_line_pars([th(k) cd_values(I(min(I1)),k)],[th(k+1), cd_values(I(min(I1)),k+1)]);
                x = -(( b1 - b2 )./( a1 - a2 ));
                res(l,I(I1)) = x;
            end;
        end;
    end;
row = sort(res(find(res)));
elseif strcmp(o.LSDMLevels,'Yes')
%% Find points of reaching of a given level
   res = [];
   row = [];
   for l = 1:size(cd_values,1)
        r = min( find( cd_values(l, : ) > o.LSDMReachedLevel ) );
       row(l) = Inf;
       if ~isempty(r)
        [a,b] = tools.find_line_pars([th(r) cd_values(l,r)],[th(r+1), cd_values(l,r+1)]);
        row(l) = -(( b - o.LSDMReachedLevel ) ./ a );
       end;
   end;
else
    error('Wrong number of input arguments');
end;
