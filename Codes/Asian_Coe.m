
S0 = 80; % Initial price of underlying asset
Sigma = 0.2;                % Volatility of underlying asset
StockSpec = stockspec(Sigma,S0); %Stock Specification
          % Strike
OptSpec = 'call';            % Call option
Startdate = '01-Jan-2015';
Settle = '30-Mar-2015';      % Settlement/Initial-valuation date
Enddate = '30-Dec-2017';
 %'31-Mar-2016'   % Maturity date of option
% Average Date (Here is at the end of each quarter)

% Set up interest rate assumptions
r = 0.06;                  % Risk-free rate per annum
Compounding = -1;           % Continuous compounding
Basis = 0;                  % Act/Act day count convention
% Create the interest-rate term structure to define |RateSpec|.
RateSpec = intenvset('ValuationDate', Startdate , 'StartDates', Startdate , ...
           'EndDates', Enddate, 'Rates', r, 'Compounding', Compounding, ...
           'Basis', Basis);
NumTrials = 1000;
NumPeriods = 200;
AvgType = 'arithmetic';
Antithetic= true;
ExerciseDates = {'30-Mar-2015', '30-Dec-2017'};
AvgDate = Startdate;
Strike = 100;
Price = asianbyls(RateSpec, StockSpec, OptSpec, Strike, Settle,ExerciseDates, ...
'NumTrials', NumTrials, 'NumPeriods', NumPeriods,'Antithetic', Antithetic,...
'AvgType', AvgType, 'AmericanOpt',1,'AvgPrice',90,'AvgDate',AvgDate);
% Time to expiration in years
