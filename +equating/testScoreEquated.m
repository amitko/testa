function res = testScoreEquated(testScore, Equating)
% res = testScoreEquated(testScore, Equating)
% testScore - culumn with testScores
% Equating - result from equating.testScoreEquating
%
% Returns column with Equated Scores

% Dimitar Atanasov, 2015
% datanasov@ir-statistics.net

res = [];

for k=1:size(testScore,1)
    res(end+1,:)= round(Equating(Equating(:,1) == testScore(k) ,3));
end