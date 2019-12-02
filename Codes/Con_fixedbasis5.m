clear;
K = 40; r = 0.06; N = 40000; M = 2000; type = true; T = 1; S0 = 36;
sig = 0.2; B=[2:1:6];
b=length(B);

N_1 = linspace(50,100000,100); M_1 = 50;
n = length(N_1);
LSM_SD_L6_test = zeros(n,b);
LSM_P_L6_test = zeros(n,b);
LSM_P_H6= zeros(n,1);
LSM_SD_H6 = zeros(n,1);
LSM_P_P6 = zeros(n,1);
LSM_SD_P6 = zeros(n,1);
FD_P = AmericanOptFD(S0,K,r,T,sig,N,M,type);
FD_P = repmat(FD_P,n,1);
for k= 1:5
    
    for i = 1:n
        
        [LSM_P_L6_test(i,k),LSM_SD_L6_test(i,k)] = AmPutLSM(S0,K,sig,r,T,N_1(i),M_1,B(k));
        [LSM_P_H6(i,1),LSM_SD_H6(i,1)] = AmPutLSM_hermite(S0,K,sig,r,T,N_1(i),M_1);
        [LSM_P_P6(i,1),LSM_SD_P6(i,1)] = AmPutLSM_Polynomials(S0,K,sig,r,T,N_1(i),M_1);
   
    end
end 
filename = 'Table.xlsx';
table2 = table(LSM_SD_L6_test,LSM_P_L6_test,LSM_P_H6,LSM_SD_H6,LSM_P_P6,LSM_SD_P6);
writetable(table2,filename,'Sheet',7,'Range','O5');
