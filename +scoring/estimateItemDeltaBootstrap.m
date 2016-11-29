function [estimatedDeltas, estimatedSE, sampleDeltas] = estimateItemDeltaBootstrap(itemResponse,options)

if nargin < 2
    options = scoring.Options();
end;

% Set Options
NofSamples       = options.NofSamplesForBootstrapping;
sampleProportion = options.sampleProportionForBootstrapping;

[NofStudents NofItems] = size(itemResponse);

sampleDeltas = [];

h = waitbar(0,['Bootstrapped 0 samples out of ' num2str(NofSamples)]);

for k = 1:NofSamples
    sampleData = itemResponse(randsample(1:NofStudents,round( NofStudents * sampleProportion )),:);
    sampleDeltas = [sampleDeltas; 1 - mean(sampleData)];
    waitbar(k/NofSamples,h,['Bootstrapped ' num2str(k) ' samples out of ' num2str(NofSamples)]);
end;

close(h);

estimatedDeltas = [];
estimatedSE = std(sampleDeltas)';

if strcmp(options.estTypeForBootstrapping,'mean')
    estimatedDeltas = mean(sampleDeltas)';
elseif strcmp(options.estTypeForBootstrapping,'mode')
    estimatedDeltas = mode(sampleDeltas)';    
elseif strcmp(options.estTypeForBootstrapping,'median')
    estimatedDeltas = median(sampleDeltas)';    
end;