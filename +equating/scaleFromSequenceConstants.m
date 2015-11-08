function [A, B] = scaleFromSequenceConstants(sequence)

As = [1];
A = 1;
B = 0;

%sequence

for k = 1:size(sequence,1)
    a = sequence(k,1);
    b = sequence(k,2);
    As = [As a];
    A = A*a;
    B = B + b * prod(As(1:k));
end;
