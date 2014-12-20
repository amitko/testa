function option = Options(varargin)

option.LatentTraitInterval  = [-7 7];

option.LSDMModel            = 1;
option.LSDMShowMad          = 'Yes';
option.LSDMReachedLevel     = 0.5;
option.LSDMLevels           = 'No';

option.IRT                  = irt.Options;

option.PlotCC               = 'Yes';


if nargin > 0
	if mod(nargin,2) ~= 0
	 error('Wrong number og input arguments');
	end;
	
	for k = 1:2:nargin
		option = setfield(option,varargin{k},varargin{k+1});
	end;
end;
