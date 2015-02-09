function [A, B] = scaleItemParameters( baseTest, targetTest, commonItems)

% baseTest    - Y (right in the sequence X->Y )
%              [discr, difficulty, guess] 
%              [          a,    b,     c] 
%   
% targetTest  - X
%              [discr, difficulty, guess] 
%              [          a,    b,     c] 
% commonItems - matrix with two rows 
%               (1,:) items indexes in base test
%               (2,:) items indexes in target test

maT = mean( targetTest( commonItems(2,:), 1 ));
mbT = mean( targetTest( commonItems(2,:), 2 ));

maB = mean( baseTest( commonItems(1,:), 1 ));
mbB = mean( baseTest( commonItems(1,:), 2 ));

A = maT/maB;
B = mbB - A * mbT;