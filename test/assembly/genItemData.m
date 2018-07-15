
 N = 10000;

 % difficulti,  discriminations, guessing
 irtPatams = [random('norm',0,3,N,1), random('unif',0.8,3,N,1), random('unif',0.1,0.3,N,1)]
 
 dScore = 1 - +expected.ItemScore(irtPatams)
 
 targetSet = randsample(N,20)
 
 th = -3:0.2:3;
 for k = 1:size(th,2)
    targetTestInfFunction(k) = +expected.TestInformation(irtPatams(targetSet,:),th(k));
 end;
 
 plot(th, targetTestInfFunction);
 
 save('itemData.mat')
