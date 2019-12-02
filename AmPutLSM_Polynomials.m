function [Price,Stderr] = AmPutLSM_Polynomials(S0,K,sigma,r,T,N,M)
dt = T/M;
t = 0:dt:T;
t = repmat(t',1,N);
S = zeros(N,M);
S(:,1) = S0;
x = randn(N/2,M);
    for i = 2:M
        S(:,i) = S(:,i-1).*(exp((r-0.5*sigma^2)*dt + sigma*sqrt(dt)*[x(:,i);-x(:,i)]));
    end
stop_time = zeros(N,1);
CF = zeros(size(S));
CF(:,end) = max(K - S(:,end),0);
X = zeros(N,1);
for ii = M-1:-1:2
    itm = find(S(:,ii)<K);
    X = S(itm,ii);
    %X = X1/S0;
    Y = exp(-r*dt)*CF(itm,ii+1);
    L= [ones(size(X)) X X.^2 X.^3 X.^4 X.^5]; %    %w = exp(-X/2);
    %L1 = zeros(size(L));
    %for i = 1:length(L)
        %L1(i,:) = w(i,1)*L(i,:);
    %end
    coef = L\Y;
    C = L*coef;
    exer = max(K-X,0)>C;
    nexer = setdiff((1:N),itm(exer));
    CF(itm(exer),ii) = max(K - X(exer),0);
    CF(nexer,ii) = exp(-r*dt)*CF(nexer,ii+1);
    stop_time(itm(exer)) = ii;
    
end
Price = mean(CF(:,2))*exp(-r*dt);
Stderr = sqrt(var(CF(:,2))/N);
end