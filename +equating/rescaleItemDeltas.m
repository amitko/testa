function res = rescaleItemDeltas( ItemDeltas, ScalingBaseDeltas, ReferenceDeltas, type)

% Function res = irT.equating.rescaleItemDeltas( ItemDeltas, ScalingBaseDeltas, ReferenceDeltas, type)
%
% Rescale ItemDeltas on the scale, defined by ScalingBaseDeltas.
% ScalingBaseDeltas and ReferenceDeltas should contain item delta values
% for the same set of items.
%
% In particular, the ReferenceDeltas and ItemDeltas are delta values,
% etimated for a given test. Some of the items (placed in ReferenceDeltas)
% have previously known delta values, consdered as etalon. These values are
% placed in ReferenceDeltas. The ItemDeltas values are rescaled to fit the
% scale of ScalingBaseDeltas.
%
% type correcponds to the algorithm of the scaling
%       'q' uses a quantile equating
%       'r' uses a regression
%
% The input data is in columns.

% Dimitr Atanasov, i-Research, 2018
% datanasov@ir-statistics.net

if nargin < 4
    type = 'q';
end;

res = [];
q = [];

n = size(ReferenceDeltas,1);

if strcmp(type,'q')
    for k = 1:size(ItemDeltas,1)
        [b,I] = sort([ReferenceDeltas',ItemDeltas(k)]);
        q(k) = find(I == n+1 ) / (n+1);
        res(k,1) = quantile(ScalingBaseDeltas,q(k));
    end;
end;

if strcmp(type,'r')
    B = regress(ScalingBaseDeltas,[ones(n,1) ReferenceDeltas])
    res = [ones(size(ItemDeltas,1),1) ItemDeltas] * B;
end;
