function option = Options(varargin)


option.NofLatentsCategories = 30;

option.LatentTraitInterval  = [-7 7];

option.LatentTraitPoints    = 30;

option.DicsriminationInterval = [0 3];
option.GuessingInterval = [0 0.3];

option.StartingDifficultyEstimated = 1;

option.StartingPoint_3PL    = [0 1 0.2];
option.StartingPoint_2PL    = [0 1];
option.StartingPoint_1PL    = 0;

option.NofIterations_EM     = 30;

P.alpha = [0 0.5];
P.b     = [0 2];
P.c     = [6 18];

option.priorDistributionParameters = P;

option.OptimisationOptions  = optimset('Display','off');
option.MaxFunTol            = 0.01;
option.MaxParTol            = 0.01;
option.irtModels            = {'1PL' '2PL' '3PL'};

option.Model                = 3;
option.D                    = 1.702;

option.MeanOfLatentTrait    = 0;
option.VarOfLatentTrait     = 2;

option.LSDMModel            = 1;
option.LSDMShowMad          = 'Yes';
option.LSDMReachedLevel     = 0.5;
option.LSDMLevels           = 'No';

option.Plot.legend          = 0;
option.Plot.colour          = 0;


if nargin > 0
	if mod(nargin,2) ~= 0
	 error('Wrong number og input arguments');
	end;
	
	for k = 1:2:nargin
		option = setfield(option,varargin{k},varargin{k+1});
	end;
end;

option.LatentTraitValues   = linspace(option.LatentTraitInterval(1),option.LatentTraitInterval(2),option.LatentTraitPoints);

option.EMAlgorithmStored = [];
