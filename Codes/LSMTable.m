
K = 40; r = 0.06; N = 40000; M = 2000; type = true; T = 1; S0 = [36:2:44];
sig = [0.2,0.4];

N_1 = 100000; M_1 = 50;
Table1.S = {reshape(repmat(36:2:44, [4,5]),[],1)};
Table1.T = {reshape(repmat([1;2], [20,1]),[],1)};
Table1.sigma = {reshape(repmat([0.2;0.4], [20,1]),[],1)};
FD_P = zeros(5,2);
LSM_P = zeros(5,2);
LSM_se = zeros(5,2);
BS_P = zeros(5,2);
for k = 1:2
    for i = 1:length(S0)
        FD_P(i,k) = AmericanOptFD(S0(i),K,r,T(1),sig(k),N,M,type);
        [LSM_P(i,k),LSM_se(i,k)] = AmPutLSM(S0(i),K,sig(k),r,T(1),N_1,M_1);
        BS_P(i,k) = BlackScholesFcn(S0(i),K,r,T(1),sig(k));
    end
end

Table1.FD_Price = [FD_P(:,1);FD_P(:,2)];
Table1.LSM_Price = [LSM_P(:,1);LSM_P(:,2)];
Table1.LSM_se = [LSM_se(:,1);LSM_se(:,2)];
Table1.Eu_Price = [BS_P(:,1);BS_P(:,2)];
filename = 'Table.xlsx';
writetable(Table1,filename,'Sheet',1,'Range','D1');


   
