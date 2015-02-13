function option = Options(varargin)

% Dimitar Atanasov, 2015
% datanasov@ir-statistics.net


    options.EquatingType = 'NCE';
    options.EquatingAdd   = [0,1];


if nargin > 0
	if mod(nargin,2) ~= 0
	 error('Wrong number og input arguments');
	end;
	
	for k = 1:2:nargin
		option = setfield(option,varargin{k},varargin{k+1});
	end;
end;
