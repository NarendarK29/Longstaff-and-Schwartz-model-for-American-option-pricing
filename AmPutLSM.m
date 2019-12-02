%=======================================================
% Least Square Monte Carlo with Weighted Laguerre Basis
%=======================================================
function [Price,Stderr] = AmPutLSM(S0,K,sigma,r,T,N,M,B)
dt = T/M; %Time steps
t = 0:dt:T;
t = repmat(t',1,N);
S = zeros(N,M); %Price matrix
S(:,1) = S0;
% Procedure to apply Control variate technique on Monte Carlo Simulation
x = randn(N/2,M);
    for i = 2:M
        S(:,i) = S(:,i-1).*(exp((r-0.5*sigma^2)*dt + sigma*sqrt(dt)*[x(:,i);-x(:,i)]));
    end
% Matrix for Stopping Time and Cash Flows
stop_time = zeros(N,1);
CF = zeros(size(S));
CF(:,end) = max(K - S(:,end),0);
X = zeros(N,1);
% Dynamic Programming
for ii = M-1:-1:2
    itm = find(S(:,ii)<K);
    X = S(itm,ii);
    Y = exp(-r*dt)*CF(itm,ii+1);
    L = [ones(size(X)) (1 - X) (1 - 2*X - 0.5*X.^2) 1/6*(6 - 18*X + 9*X.^2 - X.^3) 1/24*(X.^4-16*X.^3+72*X.^2-96*X+24) 1/120*(-X.^5+25*X.^4-200*X.^3+600*X.^2-600*X+120)];
% Weighting the Polynomials as given in script
    w = exp(-X/2);
    L1 = zeros(size(L));
    for i = 1:length(L)
        L1(i,:) = w(i,1)*L(i,:);
    end
% Regression for Continuation Value
    coef = L1(:,1:B)\Y;
    C = L1(:,1:B)*coef;
% Finding in the money option paths
    exer = max(K-X,0)>C;
    nexer = setdiff((1:N),itm(exer));
    CF(itm(exer),ii) = max(K - X(exer),0);
% Risk Neutral Discounting
    CF(nexer,ii) = exp(-r*dt)*CF(nexer,ii+1);
 % Path dependent stopping time   
    stop_time(itm(exer)) = ii;
    
end
% Price and Standard Error of Option Price
Price = mean(CF(:,2))*exp(-r*dt);
Stderr = sqrt(var(CF(:,2))/N);
end


    
    
    
    

    



