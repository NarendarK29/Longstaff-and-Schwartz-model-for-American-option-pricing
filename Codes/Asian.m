S0 = 80; % Initial price of underlying asset
Sigma = .2; % Volatility of underlying asset
Strike = 100; % Strike
OptSpec = 'call'; % Call option
Startdate = '1-Jan-2013'; % Settlement date of option
EndDate = '1-Jan-2015';
Maturity ='1-Jan-2015'; % Maturity date of option
Settle = '1-April-2013';
r = .06; % Risk-free rate (annual, continuous compounding)
Compounding = -1; % Continuous compounding
Basis = 0; % Act/Act day count convention
Avgdate = '1-Oct-2012';
AvgPrice = 90;
OptSpec = 'call'
StockSpec = stockspec(Sigma, S0);
RateSpec = intenvset('ValuationDate', Settle, 'StartDate',Settle , ...
    'EndDate',  EndDate, 'Compounding', -1, 'Rates', r)
NTrials = 10000;
NPeriod = yearfrac(Settle,EndDate,1)*100;
dt = 1/NPeriod;
AvgType= 'arithmetic';
Price = asianbyls(RateSpec,StockSpec, OptSpec,Strike, Settle,EndDate,'NumTrials',NTrials,'NumPeriods',NPeriod,'Antithetic',true,...
   'AvgType',AvgType,'AmericanOpt',1,'AvgPrice',90);
%