%Give parameter values and define variables
S = 36;
E = 40;
Smin=E*exp(-100);
Smax=E*exp(100);
r = 0.06;
d = 0;
sigma = 0.2;
T=1;
t=0;
omega=1.2;
tol=0.001;
X=log(S/E);
k=r/(0.5*sigma^2);
kd = (r-d)/(0.5*sigma^2);
M = 40000;
Nminus = -500;
Nplus = 500;
N = Nplus-Nminus;
u=zeros(N+1,M+1);
dt=(0.5*sigma^2*T)/M;
Xzero = log(Smin/E);
Xmax = log(Smax/E);
dX=(Xmax-Xzero)/N;
lambda = dt/(dX*dX);
Xmesh=Xzero:dX:Xmax;
Tmesh=0:dt:(0.5*sigma^2*T);
%Establish the payoff matrix
g = zeros(N+1,M+1);
for n=1:N+1
for m=2: M+1
g(n,m)=exp((0.25*(kd-1)^2+k)*((m-1)*dt))*(max((exp(0.5*(kd+1)*(n+Nminus-1)*dX)- exp(0.5*(kd-1)*(n+Nminus-1)*dX)),0));
end
g(n,1)= max((exp(0.5*(kd+1)*(n+Nminus-1)*dX)-exp(0.5*(kd-1)*(n+Nminus-1)*dX)),0);
end
g(1,:)=0;
%The boundary conditions of the u matrix
u(:,1)= g(:,1);
u(1,:)= g(1,:);
u(N+1,:)= g(N+1,:);
a = -lambda;
b = 1+2*lambda;
c = -lambda;
%The projected SOR algorithm
for p=1:M
temp=zeros(N-1,1);
temp(1)=a*g(1,p+1);
temp(end)=c*g(N+1,p+1);
RHS=u(2:N,p)-temp;
b=RHS;
x=max(u(2:N,p),g(2:N,p+1));
xold=1000*x;
n=length(x);
while norm(xold-x)>tol
xold=x;
for i=1:n
if i==1
z = (b(i)+lambda*x(i+1))/(1+2*lambda);
x(i) = max(omega*z + (1-omega)*xold(i),g(i,p));
elseif i==n
z = (b(i)+lambda*x(i-1))/(1+2*lambda);
x(i) = max(omega*z + (1-omega)*xold(i),g(i,p));
else
z = (b(i)+lambda*(x(i-1)+x(i+1)))/(1+2*lambda);
x(i) = max(omega*z + (1-omega)*xold(i),g(i,p));
end
end
end
u(2:end-1,p+1)=x;
end
uresult=interp1(Xmesh,u(:,M+1),X);
%Obtain the option value
value = E*E^(0.5*(kd-1))*S^(-0.5*(kd-1))*exp((-(1/4)*(kd-1)^2-k)*0.5*sigma^2*T)*uresult