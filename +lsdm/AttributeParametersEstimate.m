function parsQ = AttributeParametersEstimate(pars, Q, o)
%Function lsdm.AttributeParametersEstimate(pars, Q, o)
%   Estimates the IRT paramethers of a given set of cognitive
%   attributes over a set of IRT item parameters.
%
%   Input:
%       par - the values of the item parameters
%           each row represents one item
%           [difficulty dicriminative guest]
%       Q   - matrix of indicators that item j
%           requires attribute k  ( Q(j,k) = 1 )
%       o   - lsdm.Options
%
%   Output:
%       IRT paramethers of the attributes

% Dimitar Atanasov, 2016
% datanasov@ir-statistics.net


if nargin == 2
    o = irT.lsdm.Options;
end;

th = o.IRT.LatentTraitValues;

p = irT.irt.LogisticProbability(pars,th);

attr_prob = irT.lsdm.AttributePerformance(p,Q,o);

parsQ = [];
for k = 1:size(attr_prob,1)
   parsQ(k,:) = irT.irt.Fit(th, attr_prob(k,:) );
end;

if strcmp(o.PlotCC,'Yes')
    opt.legend = 1;
	opt.colour  = 1;

	irT.irt.PlotItem(parsQ,th,opt)
end;
