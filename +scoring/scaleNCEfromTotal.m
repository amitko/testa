function res = scaleNCEfromTotal(score, MeanScore, stdScore)

% Dimitar Atanasov, 2015
% datanasov@ir-statistics.net


z = ( score - MeanScore ) ./ stdScore;

res = z.* 21.063 + 50;

res(find(res < 1 ))  = 0;
res(find(res > 99)) = 100;
