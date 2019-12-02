T =2;
dt = T/100;
N = 500;
M = 100;
r = 0.06;
sigma = 0.2;
gbmOpt = gbm(r,sigma,'StartState',80);
[Paths,Times] = simBySolution(gbmOpt, M,...
    'NTRIALS',N, 'DeltaTime',dt,'Antithetic',true);
S = squeeze(Paths)';
plot(S(:,1:50));