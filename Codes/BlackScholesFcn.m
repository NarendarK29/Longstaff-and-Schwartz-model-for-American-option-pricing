%=======================================================
% Black Scholes for European Option Table 1
%=======================================================

function [P] = BlackScholesFcn(S0,K,r,T,s)
% S0- Asset price
%K - strike price
% r - risk free interest rate
% T - maturity
% s - volatility
d1 = (log(S0/K)+(r+0.5*s^2)*T)/(s*sqrt(T));
d2 = d1-s*sqrt(T);
P = K*exp(-r*T)*normcdf(-d2)-S0*normcdf(-d1);
end