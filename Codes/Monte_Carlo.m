close all
clear all
% ========================
% Parameters of American Options
% ========================
% Stock
sigma=.2; % Volatility
S0=36; % Initial price
% Interest rate and Dividend Yield
r=.06;
D=0;
% Options
T=1; % Time to Maturity
KP=40; % Strike Price
% ===================
% Monte Carlo Simulations
% ===================
dt =1/200; %Lenght of the interval of time
N=T/dt; %Number of periods to simulate the price of the stock
NSim=1; %Munber of simulations
dBt=sqrt(dt)*randn(NSim,N); % Brownian motion
St=zeros(NSim,N); % Initialize matrix
St(:,1)=S0*ones(NSim,1); % vector of initial stock price per simulation
for t=2:N;
St(:,t)=St(:,t-1).*exp((r-D-.5*sigma^2)*dt+sigma*dBt(:,t)); %simulation of prices
end
t = linspace(0,1,200);
plot(t',St);
plot(t',t.^2');
MM = exp(-r*dt)*(St(:,4)- KP);
X = [St(:,3),St(:,3).^2];
Beta = inv(X'*X)*X'*MM;
