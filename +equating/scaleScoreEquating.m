function res = scaleScoreEquating (Data, options)

% Dimitar Atanasov, 2015
% datanasov@ir-statistics.net

if nargin < 2
    option = irT.equating.Options();
end;

if strcmp(options.EquatingType,'NCE')
    res = irT.cls.scaleNCEfromTotal(Data(:,3), options.EquatingAdd(1), options.EquatingAdd(2));

elseif strcmp(options.type,'SubDomain')
    % options.add = [numberOfItemsInTheTest]
    res = Data(:,3) .* (size(Data,1) / options.EquatingAdd(1));
else
    res = [];
end;
