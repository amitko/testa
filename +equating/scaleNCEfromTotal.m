function res = scaleNCEfromTotal(score, MeanScore, stdScore)

z = ( score - MeanScore ) ./ stdScore;

res = z.* 21.063 + 50;

res(find(res < 1 ))  = 0;
res(find(res > 99)) = 100;
