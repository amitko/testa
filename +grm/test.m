%% Init data
itemThresholds = random('norm',0,1,10,2);
abilityValues   = random('norm',0,1,1,100); % 100 observations

itemThresholds = [itemThresholds(:,1) itemThresholds(:,1) + abs(itemThresholds(:,2))]

%% Generate Data
itemResponse = irT.grm.generateData(itemThresholds, ones(size(itemThresholds)) , abilityValues)

%% Estimate parameters
estimatedItemThresholds = irT.grm.estimate(itemResponse, zscore(sum(itemResponse,2))  )
%% Plot an aitem
irT.grm.plotItem(estimatedItemThresholds(1,:))

%% Items True Score for a Persons
ItemsTrueScore = [];
for item = estimatedItemThresholds'
       ItemsTrueScore(:, end+1) = irT.grm.itemTrueScore(item',abilityValues);
end;
ItemsTrueScore

%% item Expected True Score Variance for person
ItemExpectedTrueScoreVariance = [];
for item = estimatedItemThresholds'
       ItemExpectedTrueScoreVariance(:, end+1) = irT.grm.expectedTrueScoreVariance(item', abilityValues);
end;
ItemExpectedTrueScoreVariance

%% Test True Score
irT.grm.testTrueScore(itemThresholds)

%% Test Information
irT.grm.testInformation(itemThresholds)


%% item Expected True Variance for person
ItemExpectedTrueVariance = [];
for item = estimatedItemThresholds'
       ItemExpectedTrueVariance(:, end+1) = irT.grm.itemExpectedTrueVariance(item', abilityValues);
end;
ItemExpectedTrueVariance
