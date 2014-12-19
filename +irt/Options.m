function option = Options(varargin)


option.NofLatentsCategories = 30;

option.LatentTraitInterval  = [-7 7];
option.DicsriminationInterval = [0 3];
option.GuessingInterval = [0 0.3];

option.StartingPoint_3PL    = [0 1 0.1];
option.StartingPoint_2PL    = [0 1];
option.StartingPoint_1PL    = 0;
option.NofIterations_EM     = 50;
option.OptimisationOptions  = optimset('Display','iter');
option.MaxFunTol            = 1;
option.irtModels            = {'1PL' '2PL' '3PL'};
option.Model                = 1;
option.D                    = 1.702;

option.LSDMModel            = 1;
option.LSDMShowMad          = 'Yes';
option.LSDMReachedLevel     = 0.5;
option.LSDMLevels           = 'No';

if nargin > 0
	if mod(nargin,2) ~= 0
	 error('Wrong number og input arguments');
	end;
	
	for k = 1:2:nargin
		option = setfield(option,varargin{k},varargin{k+1});
	end;
end;

