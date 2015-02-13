function [A,B,S,SA] = scaleTestSequence(testSequence, commonItems)
% [A,B,S,SA] = scaleTestSequence(testSequence, commonItems)
% this function calls scaleItemParameters
%
% The first element in test sequence should be
% the base test Y
% Y<-X1<-X2<-X3 .... 
%
% testSequence is a cellarray of target tests
% commonItems is a cell array of common item sets

% Dimitar Atanasov, 2015
% datanasov@ir-statistics.net

if length(testSequence) ~= length(commonItems) + 1
    error('Number of tests in sequence should match number of common items');
end;

As = [1];
A = 1;
B = 0;
S = [];
SA = [];

for k = 1:length(testSequence)-1
    [a,b] = scaleItemParameters(testSequence{k},testSequence{k+1},commonItems{k});
    S(k,:) = [a b];
    As = [As a];
    A = A*a;
    B = B + b * prod(As(1:k));
    SA(k,:) = [A,B];
end;



