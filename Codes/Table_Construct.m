%=======================================================
% Table 1
%=======================================================
clear;
% Parameters of Put options
K = 40; r = 0.06; N = 40000; M = 2000; type = true; N_1 = 100000; M_1 = 50;
% Parameters
S0 = reshape(repmat(80:5:100, [4,1]),[],1);
T = reshape(repmat([1;2], [10,1]),[],1);
Sigma = reshape(repmat([0.2;0.2;0.4;0.4], [5,1]),[],1);
P = [S0, Sigma, T];
% Price Matrix
FD_P = zeros(20,1);
LSM_P = zeros(20,1);
LSM_se = zeros(20,1);
BS_P = zeros(20,1);
% Loop going for each set of variables
    for i = 1:length(P)
        FD_P(i) = AmericanOptFD(P(i,1),K,r,P(i,3),P(i,2),N,M,type);
        [LSM_P(i),LSM_se(i)] = AmPutLSM(P(i,1),K,P(i,2),r,P(i,3),N_1,M_1);
        BS_P(i) = BlackScholesFcn(P(i,1),K,r,P(i,3),P(i,2));
    end
% Early Exercise value    
Eearly_Ex_LSM = LSM_P - BS_P;
Eearly_Ex_FD = FD_P - BS_P;
Diff = Eearly_Ex_FD - Eearly_Ex_LSM;
Table = table(S0,Sigma,T,FD_P,BS_P,Eearly_Ex_FD, LSM_P,LSM_se, Eearly_Ex_LSM, Diff);
filename = 'Table.xlsx';
writetable(Table,filename,'Sheet',7,'Range','H5');

