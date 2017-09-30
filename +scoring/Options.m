function option = Options(varargin)

% for bootstrapping
option.NofSamplesForBootstrapping = 1000;
option.sampleProportionForBootstrapping = 0.1;
option.estTypeForBootstrapping = 'mode';

%for logistics fit
option.dScale = [0:0.05:1]';
option.StartingPoint = [1 0.5 0.1];
option.Models = { '', ...
           '1-(1/(1+(x/B)^A))',...
           '1-((1-G)/(1+(x/B)^A))',...
           'U-((1-G)/(1+(x/B)^A))'
           };
option.Model_coefficients = {'A', 'B', 'G', 'U'};       
option.model = 2;
option.type = 'prop';
option.param_lb = [0.01 0.01 0.01];       
option.param_ub = [5    0.99 0.35];       




if nargin > 0
	if mod(nargin,2) ~= 0
	 error('Wrong number og input arguments');
	end;
	
	for k = 1:2:nargin
		option.(varargin{k}) = varargin{k+1};
	end;
end;
