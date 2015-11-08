function res = testScoreEquating(itemParameters1,itemParameters2,th)
% itemParameters are for Test score 1

res = [];

T1 = expected.TestTrueScore(th,itemParameters1);
T2 = expected.TestTrueScore(th,itemParameters2);

c1 = sum(itemParameters1(:,3));
c2 = sum(itemParameters2(:,3));

for k = 0:floor(c2)
    res = [res; [k NaN c1/c2*k]];
end;

[m, b] = str_line(floor(c2), c1, floor(min(T2)), min(T1));

for k = floor(c2) + 1  : floor(min(T2))
    res = [res; [k NaN m*k + b]];
end;

for ts = floor(min(T2)) + 1 : floor(max(T2)) 
    I1 = max(find( T2 < ts ));
    I2 = min(find( T2 > ts ));
    
    [Srt, Sri] = sort([ abs(mean(th(I1)) - ts) , abs(mean(th(I2)) - ts)]);
    
    val = [mean(th(I1)), mean(th(I2))];
    
    res = [res; [ts val(Sri(1)) expected.TestTrueScore( val(Sri(1)), itemParameters1 ) ] ];
end;

[m, b] = str_line(floor(max(T2)), floor(max(T1)), size(itemParameters2), size(itemParameters2));

for k = floor(max(T2))+1: size(itemParameters2)
    v = res(end,2)*2 - res(end-1,2);
    res = [res; [k v m*k + b]]; % extrapolated using first order teylor series
    %res = [res; [k NaN m*k + b]];
end;


function [m, b] = str_line(x1, y1, x2, y2)
m = (y2-y1) / (x2-x1);
b = y1 - m*x1;