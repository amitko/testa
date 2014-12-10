function res = clsStratifiedAlpha(item_response1, item_response2)
% function clsStratifiedAlpha(item_response1, item_response2)
% calculates the stratified alpha coefficient

% Dimitar Atanasov, 2014
% danatasov@ir-statistics.net

v1 = var(sum(item_response1'));
v2 = var(sum(item_response2'));
v  = var(sum([item_response2 item_response2]'));

res = 1 - ((1 - clsCrAlpha(item_response1))* v1 + (1 - clsCrAlpha(item_response2))* v2 ) / v;
 
