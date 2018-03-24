function res = transformTestParameters(origTestParameters, A, B)

% Function res = irT.equating.transformTestParameters(origTestParameters, A, B)
% Transforming test parameters to the test at the end of the sequence
%

% Dimitar Atanasov, i-Research, 2018
% datanasov@ir-statistics.net

res = [];
for k = 1:size(origTestParameters,1)
    res = [res; [origTestParameters(k,1)*A + B, origTestParameters(k,2)/A, origTestParameters(k,3)]];
end;
