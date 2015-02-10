function res = transformTestParameters(origTestParameters, A, B)

% Transforming test parameters to the test at the end of the sequence
%


res = [];
for k = 1:size(origTestParameters,1)
    res = [res; [origTestParameters(k,1)*A + B, origTestParameters(k,2)/A, origTestParameters(k,3)]];
end;