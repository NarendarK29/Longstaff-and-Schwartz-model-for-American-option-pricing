    %=======================================================
    % Least Square Monte Carlo with Hermite Polynomials
    %=======================================================
function [Price,Stderr] = AmPutLSM_hermite(S0,K,sigma,r,T,N,M,B)

%   S0      Initial asset price
%   K       Strike Price
%   r       Interest rate
%   T       Time to maturity of option
%   sigma   Volatility of underlying asset
%   N       Number of points in simulated
%   M       Number of time steps
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
    L = [ones(size(X)) 2*X  4*X.^2-2 8*X.^3-12*X 16*X.^4-48*X.^2+12 32*X.^5-160*X.^3+120*X];
% Regression for Continuation Value
    coef = L1(:,1:B)\Y;
    C = L1(:,1:B)*coef;
% Finding in the money option paths (mathwork.com)
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
