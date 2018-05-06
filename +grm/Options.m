function option = Options(varargin)

option.thInterval = [-3, 3];
option.thresholdValuesStart = 0;
option.D = 1.702;
option.thresholdsType = 'thresholds'; % or 'grades' // in logistic_probability

option.LatentTraitValues = -3:.2:3;

option.itemDiscrimination = 1;
option.guessing = 0;

if nargin > 0
	if mod(nargin,2) ~= 0
	 error('Wrong number og input arguments');
	end;
	
	for k = 1:2:nargin
		option = setfield(option,varargin{k},varargin{k+1});
	end;
end;
