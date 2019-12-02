S0 = 80; % Initial price of underlying asset
Sigma = .2; % Volatility of underlying asset
Strike = 100; % Strike
OptSpec = 'call'; % Call option
Settle = '1-Jan-2013'; % Settlement date of option
Maturity = '1-Jan-2015'; % Maturity date of option
Startdate = '1-April-2013';
r = .06; % Risk-free rate (annual, continuous compounding)
Compounding = -1; % Continuous compounding
Basis = 0; % Act/Act day count convention
T = yearfrac(Settle, Maturity, Basis); % Time to expiration in years
NTRIALS = 1000;
NPERIODS = yearfrac(Settle, Maturity)*100
%NPERIODS = 175;
dt = 1/NPERIODS;
OptionGBM = gbm(r, Sigma, 'StartState', S0);
[Paths, Times, Z] = simBySolution(OptionGBM, NPERIODS, ...
'NTRIALS',NTRIALS, 'DeltaTime',dt,'Antithetic',true);
RateSpec = intenvset('ValuationDate',Settle, 'StartDates', Settle, ...
           'EndDates', Maturity, 'Rate', r, 'Compounding', Compounding, ...
           'Basis', Basis)
       %Paths(1,:,:) = 90;
       AvgPrices = zeros(NPERIODS+1, NTRIALS);
       
    for i = 1:NPERIODS+1
        AvgPrices(i,:) = mean(squeeze(Paths(1:i,:,:)));
    end
    AvgPrice(1,:) = 110;
    AsianPrice = optpricebysim(RateSpec, AvgPrices, Times, OptSpec, ...
        Strike, T, 'AmericanOpt', 1)
    PriceToday = exp(-r*0.25)*AsianPrice