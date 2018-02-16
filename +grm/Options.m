function option = Options(varargin)

option.thInterval = [0,1]
option.thresholdValuesStart = 0;
options.D = 1.702;
options.thresholdsType = 'thresholds'; % or 'grades' // in logistic_probability



if nargin > 0
	if mod(nargin,2) ~= 0
	 error('Wrong number og input arguments');
	end;
	
	for k = 1:2:nargin
		option = setfield(option,varargin{k},varargin{k+1});
	end;
end;
