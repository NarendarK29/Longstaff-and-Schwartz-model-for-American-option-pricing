close all
clear all
% ========================
% Parameters of American Options
% ========================
% Stock
sigma= .2; % Volatility
S01=36; % Initial price
S02=26;
% Interest rate and Dividend Yield
r=.06;
D=0;
% Options
T=1; % Time to Maturity
KP=40; % Strike Price
% ===================
% Monte Carlo Simulations
% ===================
dt =1/50; %Lenght of the interval of time
N=T/dt; %Number of periods to simulate the price of the stock
NSim=10000; %Munber of simulations
dBt1=sqrt(dt)*randn(NSim,N);
dBt2=sqrt(dt)*randn(NSim,N); % Brownian motion
St1=zeros(NSim,N);
St2=zeros(NSim,N); % Initialize matrix
St1(:,1)=S01*ones(NSim,1); % vector of initial stock price per simulation
St2(:,1)=S02*ones(NSim,1);
for t=2:N;
St1(:,t)=St1(:,t-1).*exp((r-D-.5*sigma^2)*dt+sigma*dBt1(:,t));
St2(:,t)=St2(:,t-1).*exp((r-D-.5*sigma^2)*dt+sigma*dBt2(:,t));
%simulation of prices
end
SSit1=St1;
SSit2=St2; % just change the name
NSim=size(SSit1,1); % Number of simulations
NSim=size(SSit2,1);
%===============================
% Computing the value of American Options
%===============================
% Work Backwards
% Initialize CashFlow Matrix
MM=NaN*ones(NSim,N);
MM(:,N)=max(KP-max(SSit1(:,N), SSit2(:,N)),0);
for tt=N:-1:3;
% Step 1: Select the path in the money at time tt-1
I=find(KP-max(SSit1(:,tt-1), SSit2(:,tt-1))>0);
ISize=length(I);
% Step 2: Project CashFlow at time tt onto basis function at time tt-1
if tt==N
YY=(ones(ISize,1)*exp(-r*[1:N-tt+1]*dt)).*MM(I,tt:N);
else
YY=sum(((ones(ISize,1)*exp(-r*[1:N-tt+1]*dt)).*MM(I,tt:N))')';
end
SSb=max(SSit1(I,tt-1), SSit2(I,tt-1));
XX=[ones(ISize,1),SSb,SSb.^2,SSb.^3];
BB=inv(XX'*XX)*XX'*YY;
SSb2=max(SSit1(:,tt-1), SSit2(:,tt-1));
XX2=[ones(NSim,1),SSb2,SSb2.^2,SSb2.^3];
% Find when the option is exercised:
IStop=find(KP- max(SSit1(:,tt-1), SSit2(:,tt-1))>=max(XX2*BB,0));
% Find when the option is not exercised:
ICon=setdiff([1:NSim],IStop);
% Replace the payoff function with the value of the option (zeros when
% not exercised and values when exercised):
MM(IStop,tt-1)=KP- max(SSit1(IStop,tt-1), SSit2(IStop,tt-1));
MM(IStop,tt:N)=zeros(length(IStop),N-tt+1);
MM(ICon,tt-1)=zeros(length(ICon),1);
end
YY=sum(((ones(NSim,1)*exp(-r*[1:N-1]*dt)).*MM(:,2:N))')';
Value=mean(YY)
sterr=std(YY)/sqrt(NSim)