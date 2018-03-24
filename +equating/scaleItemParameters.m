function [A, B] = scaleItemParameters( baseTest, currentTest, commonItems)
% Function [A, B] = irT.equating.scaleItemParameters( baseTest, targetTest, commonItems)
% baseTest    - Y (right in the sequence X->Y )
%              [difficulty, discr, guess]
%              [          b,    a,     c]
%
% currentTest  - X
%              [difficulty, discr, guess]
%              [          b,    a,     c]
% commonItems - matrix with two rows
%               (1,:) items indexes in base test
%               (2,:) items indexes in target test

% Dimitar Atanasov, i-Research, 2018
% datanasov@ir-statistics.net

maT = mean( currentTest( commonItems(2,:), 2 ));
mbT = mean( currentTest( commonItems(2,:), 1 ));

maB = mean( baseTest( commonItems(1,:), 2 ));
mbB = mean( baseTest( commonItems(1,:), 1 ));

A = maT/maB;
B = mbB - A * mbT;
