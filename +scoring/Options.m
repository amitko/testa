function option = Options(varargin)

option.NofSamplesForBootstrapping = 1000;
option.sampleProportionForBootstrapping = 0.1;
option.estTypeForBootstrapping = 'mode';

if nargin > 0
	if mod(nargin,2) ~= 0
	 error('Wrong number og input arguments');
	end;
	
	for k = 1:2:nargin
		option.(varargin{k}) = varargin{k+1};
	end;
end;
