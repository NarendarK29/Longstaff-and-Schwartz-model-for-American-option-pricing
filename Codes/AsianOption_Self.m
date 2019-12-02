function [Price,StdError] = AsianOption(S0,K,A,r,sigma,N,M,T)
dt = T/M;
OptGBM = gbm(r,sigma,'StartState',S0);
[Paths,Times] = simBySolution(OptGBM,M,'NTRIALS',N,'DeltaTime',dt,'Antithetic',true);
S = squeeze(Paths);
AvgPrice = zeros(N,M+1);
AvgPrice(:,1) = 90;
    for i  = 2:M+1
        AvgPrice(:,i) = mean(S(1:i,:));
    end
Price = Zeros(N,M+1);
end
S0 = 80; A = 90; K = 100; r = 0.06; sigma = 0.2;
M = 200; N = 1000; T = 2;
P = AsianOption(S0,K,A,r,sigma,N,M,T)