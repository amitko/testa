%% INIT
clear
addpath('../../');

p = 0.1:0.1:0.9;
N = [1000 5000 10000]

%% Generate data, estimate 1PL parametrs and calculate expected item score
% uses cls.GenerateData and generation is based only on probability for
% correct performance
PL1 = {};
EPi1 = [];
PL3 = {};
EPi3 = [];
Observed = [];
for N_ = N
    Data = cls.GenerateData(N_,p);
    
    o1 = irt.Options('Model',1,'OptimisationOptions',optimset('Display','off'));
    PL1{end+1} = irt.ItemParametersEstimate_ML(Data,[],[o1]);

    o3 = irt.Options('Model',3,'OptimisationOptions',optimset('Display','off'));
    PL3{end+1} = irt.ItemParametersEstimate_ML(Data,[],o3);
    
    EPi_ = [];
    for p_ = PL1{end}'
        EPi_(end+1) = expected.ItemScore(p_);
    end;
    EPi1(:,end+1) = EPi_';

    EPi_ = [];
    for p_ = PL3{end}'
        EPi_(end+1) = expected.ItemScore(p_');
    end;
    EPi3(:,end+1) = EPi_';
    Observed(:,end+1) = mean(Data)';
end;


%% present the results
for k = 1:size(N,2)
    disp(['Observations ' num2str(N(k))]);
    tab = table(p',Observed(:,k),EPi1(:,k),PL1{k},EPi3(:,k),PL3{k},'VariableNames',{'Prob', 'ObsProb', 'EstProb1', 'IRT_1PL', 'EstProb3', 'IRT_3PL'});
    disp(tab)
    disp('=================================');
end;
