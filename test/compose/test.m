
load('itemData.mat')
targetTestInfFunctionDN = targetTestInfFunction;
targetTestInfFunctionUP = targetTestInfFunction+1.1;

tic
inc = compose.singleTest(100,irtPatams,'abilityScaleValues',th,'targetInfFunctionValuesDN',targetTestInfFunctionDN,'targetInfFunctionValuesUP',targetTestInfFunctionUP);
toc

resultsTIF = expected.TestInformation(irtPatams(inc,:),th)

plot(th,targetTestInfFunctionDN,'k',th,targetTestInfFunctionUP,'k',th,resultsTIF,'r')
