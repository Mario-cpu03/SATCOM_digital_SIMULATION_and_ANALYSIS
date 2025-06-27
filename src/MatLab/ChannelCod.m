%%% ChannelCod Script

%% The script ChannelCod.m is responsible for the BER and throughput evaluation 
% on a Convolutional coded channel.

% The coding rate will be of 1/2, the bare minimun, due to the assumption
% of non-critical communications.

% For the same reason, no encryption methods will be implemented.

% Another fundamental assumption is that the two terrestial nodes represent
% operative military bases, so their reception systems and antennas 
% will be stationary.

% Weather conditions will follow the assumption of equiprobability, 
% in order to model different meteorological conditions without focusing 
% on the geolocation of the nodes or other parameters. These conditions 
% will be represented by the temperature "T", pressure "P", and atmospheric 
% water vapor density "Den".
% In this context, T and Den will be random variables strictly 
% correlated with the Atmospheric Attenuation (L). Note that this quantity 
% will vary depending on the considered link, due to the different carrier 
% frequencies.
% For simplicity, scintillation effects will not be considered.

function [] = ChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck)
%% Weather condition random variables construction: Uniform continuous distributions  
% Two losses will be produced: one for the Node->Sat 
% link and one for the Sat->Node link.

% Temperature in Kelvin (0-37 degree Celsius)
T = unifrnd(270,310); 
% 0°C
T0 = 273.15; 
% Atmospheric Pressure in Pa, set to sea-level values
P = 101300.0;
% Relative Umidity
RU = unifrnd(0,1);
% Gas constant for water vapor
R = 461.5; 
% Saturation Pression of water vapor in Pa
P0 = 611;
% Latent heat of vaporization of water in J/kg
L = 2.25e6;
% Saturation Pression of the gas
SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
% Vapor density Calculated with Clausius-Clapeyron law
Den = (RU * SatP) / (R * T);
% Distance from the satellatie
range = 36000e3;
% Frequency of the carrier
freqsend = 10e9;
freqback = 8e9;


%% Atmospheric Losses random variables construction

% Loss Node->Sat in dB
Lsend = gaspl(range,freqsend,T,P,Den);
% Loff Sat->Node in dB
Lback = gaspl(range,freqback,T,P,Den);


%% MonteCarlo communications simulation

for (i = 1:MonteCarlo)
    
end

end