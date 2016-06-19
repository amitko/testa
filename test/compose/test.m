
load('itemData.mat')

targetTestInfFunctionDN = targetTestInfFunction;
targetTestInfFunctionUP = targetTestInfFunction+1.1;

%% Single Test

tic
inc = compose.singleTest(100,irtPatams,'abilityScaleValues',th,...
                        'targetInfFunctionValuesDN',targetTestInfFunctionDN,...
                        'targetInfFunctionValuesUP',targetTestInfFunctionUP,...
                        'requiredItems',[100 1000 5000]...
                        );
toc

resultsTIF = expected.TestInformation(irtPatams(inc,:),th)

plot(th,targetTestInfFunctionDN,'k',th,targetTestInfFunctionUP,'k',th,resultsTIF,'r')


%% Multiple Test

tic
inc = compose.multipleTest(3,100,irtPatams,'abilityScaleValues',th,...
                        'targetInfFunctionValuesDN',targetTestInfFunctionDN,...
                        'targetInfFunctionValuesUP',targetTestInfFunctionUP,...
                        'requiredItems',[100 1000 5000]...
                        );
toc


resultsTIF = [];
for k = 1:size(inc,2)
    resultsTIF(:,k) = expected.TestInformation(irtPatams(inc(:,k),:),th)
end


hold on;
plot(th,targetTestInfFunctionDN,'k',th,targetTestInfFunctionUP,'k')
for k = 1:size(inc,2)
    plot(th,resultsTIF(:,k),'r')
end
hold off