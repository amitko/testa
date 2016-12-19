function res = testScoreEquated(testScore, Equating,type)
% res = testScoreEquated(testScore, Equating)
% testScore - culumn with testScores
% Equating - result from equating.testScoreEquating
%
% Returns column with Equated Scores

% Dimitar Atanasov, 2015
% datanasov@ir-statistics.net

res = [];

if nargin < 3
    type = '';
end;

for k=1:size(testScore,1)
    
    if strcmp(type,'limit')
        res(end+1,:) = min(round(Equating(Equating(:,1) == testScore(k) ,3)), max(Equating(:,1)) );
    else
        res(end+1,:) = round(Equating(Equating(:,1) == testScore(k) ,3));
    end;
end