function res = scalEdScore(dScore,dScoreMax, type)

% Dimitar Atanasov, i-Research, 2018
% datanasov@ir-statistics.net

if nargin < 3
    type = 'simple';
end;

if strcmp(type,'simple')
    res = round((dScore ./ dScoreMax) * 100);
end;

if strcmp(type,'norm')
    res = round(100*cdf('norm',dScore,mean(dScore),std(dScore)^2));
end;

if strcmp(type,'perc')
    for k = 1:size(dScore,1)
        res(k,:) = round((length( dScore(dScore<dScore(k) ) )+0.5)/length(dScore)*100);
    end;
end;

if strcmp(type,'range')
    res = round(dScore * 100);
end;
