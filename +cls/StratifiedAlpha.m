function res = StratifiedAlpha(item_response1, item_response2)

% Function irT.cls.StratifiedAlpha(item_response1, item_response2)
% calculates the stratified alpha coefficient

% Dimitar Atanasov, i-Research, 2018
% danatasov@ir-statistics.net

v1 = var(sum(item_response1'));
v2 = var(sum(item_response2'));
v  = var(sum([item_response2 item_response2]'));

res = 1 - ((1 - irT.cls.CrAlpha(item_response1))* v1 + (1 - irT.cls.CrAlpha(item_response2))* v2 ) / v;

