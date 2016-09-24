
load('itemData.mat')

targetTestInfFunctionDN = targetTestInfFunction;
targetTestInfFunctionUP = targetTestInfFunction+1.1;

%% Single Test

% 5 domains
domains = 5;
itemsInDomain = size(irtPatams,1) / domains;
DomainRestriction = zeros(domains,size(irtPatams,1));
for k = 1:domains
    DomainRestriction(k, (k-1)*itemsInDomain + 1 : k*itemsInDomain  ) = 1;
end;

DomainR = [6 6 6 6 6]';


tic
inc = assembly.singleTest(30,irtPatams,'abilityScaleValues',th,...
                        'targetInfFunctionValuesDN',targetTestInfFunctionDN,...
                        'targetInfFunctionValuesUP',targetTestInfFunctionUP,...
                        'requiredItems',[100 1000 5000],...
                        'addEqualitiesLHS',DomainRestriction,...
                        'addEqualitiesRHS',DomainR...
                        );
toc

resultsTIF = expected.TestInformation(irtPatams(inc,:),th)

plot(th,targetTestInfFunctionDN,'k',th,targetTestInfFunctionUP,'k',th,resultsTIF,'r')


%% Multiple Test

tic
inc = assembly.multipleTest(3,30,irtPatams,'abilityScaleValues',th,...
                        'targetInfFunctionValuesDN',targetTestInfFunctionDN,...
                        'targetInfFunctionValuesUP',targetTestInfFunctionUP,...
                        'requiredItems',[100 1000 5000; 110 1010 5010; 120 1020 5020],...
                        'addEqualitiesLHS',DomainRestriction,...
                        'addEqualitiesRHS',DomainR...
                        );
toc
%%

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
