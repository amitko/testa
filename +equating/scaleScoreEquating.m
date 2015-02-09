function res = scaleScoreEquating (Data, options)

if nargin < 2
    options.type = 'NCE';
    options.add   = [0,1];
end;

if strcmp(options.type,'NCE')
    res = scaleNCEfromTotal(Data(:,3), options.add(1), options.add(2));

elseif strcmp(options.type,'SubDomain')
    % options.add = [numberOfItemsInTheTest]
    res = Data(:,3) .* (size(Data,1) / options.add);
else
    res = [];
end;
