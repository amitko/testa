function [A, B] = scaleItemParameters( baseTest, targetTest, commonItems)
% Function [A, B] = equating.scaleItemParameters( baseTest, targetTest, commonItems)
% baseTest    - Y (right in the sequence X->Y )
%              [difficulty, discr, guess] 
%              [          b,    a,     c] 
%   
% targetTest  - X
%              [difficulty, discr, guess] 
%              [          b,    a,     c] 
% commonItems - matrix with two rows 
%               (1,:) items indexes in base test
%               (2,:) items indexes in target test

maT = mean( targetTest( commonItems(2,:), 2 ));
mbT = mean( targetTest( commonItems(2,:), 1 ));

maB = mean( baseTest( commonItems(1,:), 2 ));
mbB = mean( baseTest( commonItems(1,:), 1 ));

A = maT/maB;
B = mbB - A * mbT;