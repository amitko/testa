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

% Dimitar Atanasov, 2014
% datanasov@ir-statistics.net


if nargin == 2
    o = lsdm.Options;
end;

th = o.IRT.LatentTraitValues;

for k = 1:size(Q,1)
   p(k,:) = irt.LogisticProbability(pars(k,:),th);
end;

attr_prob = lsdm.AttributePerformance(p,Q,o);

parsQ = [];
for k = 1:size(attr_prob,1)
   parsQ(k,:) = irt.Fit(th, attr_prob(k,:) );
end;

if strcmp(o.PlotCC,'Yes')
    opt.legend = 1;
	opt.colour  = 1;
	
	irt_plot_item(parsQ,th,opt)
end;
