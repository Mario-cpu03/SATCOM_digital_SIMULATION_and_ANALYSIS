%%% Main Script

%% The script Main.m is responsible for the execution of all the other
% scripts.
% It receivs just MonteCarlo as input parameter.
% MonteCarlo is to intend as the cardinality of the results sample 
% (number of times the simulation is repeated)

% Other relevant parameters are:

% "NumMessages" is the number of total messages that the two nodes will
% send. In this optic, Tx base will send a text message representing a
% command to the Rx base. The Rx will answer with a state message as soon 
% as the command is executed succesfully or failed. The Txbase  will send an Ack
% message to confirm it has received the answer and close the
% communication. The geostationary satellite will act as a relay.
% From now on, the term "communication" will refer to the process of
% transmitting all three messages and, in this context, will be used as
% a synonym for "simulation".

% "Bit*" is the data dimension in bit for every message. We'll suppose a Tx text
% message of medium-low size (512 bit), an Rx state message of 256 bit and a
% 8 bit Tx Acknowledgement message.

% Data dimensions and Modulation schema (QPSK) are chosen as defined in the 
% MIL-STD-188 protocol.

% Transmissive Power per Link will not be fixed, due to the needs of perfomance
% evaluation, and it's value will vary according to MIL-STD-188 protocol
% between 1W and 50W.

% Frequency Band choice, one more time accordingly with the chosen
% protocol, is an SHF X-band (8-12GHz)

% System's performance will be evaluated using mostly BER and effective
% Throughput. Other performance parameters will be PER and SNR, but their
% role will be a marginal one.

% Weather conditions will follow the assumption of equiprobability, 
% in order to model different meteorological conditions without focusing 
% on the geolocation of the nodes or other parameters. These conditions 
% will be expressed through the temperature "T", pressure "P", and atmospheric 
% water vapor density "den".
% In this context, WeatherCond will be a random variable strictly 
% correlated with the Atmospheric Attenuation (L). Note that this quantity will 
% change in respect to the link considered, due to the different carrier 
% For simplicity, scintillation effects will not be considered.

function [] = Main(MonteCarlo)

%% Init Parameters

NumMessages = 3;
BitTx = 512; BitRx = 256; BitAck = 8;

%% Weather condition random variables construction: Uniform continuous distributions  
% An array of two observation will be produced: one for the Node->Sat 
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
% Saturation Pression of water vapor
P0 = 611;
% Latent heat of vaporization of water in J/kg
L = 2.25e6;
% Saturation Pression of the gas
SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
% Vapor density Calculated with Clausius-Clapeyrom law
Den = (RU * SatP) / (R * T);
% Distance from the satellatie
range = 36000e3;

% Frequency of the carrier
freqsend = 10e9;
freqback = 8e9;
% Loss Node->Sat
Lsend = gaspl(range,freqsend,T,P,Den);
disp(Lsend);
% Loff Sat->Node
Lback = gaspl(range,freqback,T,P,Den);
disp(Lback);

fprintf('\n*************\n');
BerDataNoCode = NoChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck);
fprintf('\n*************\n');

fprintf('\n*************\n');
BerDataCode = ChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck);
fprintf('\n*************\n');

fprintf('\n*************\n');
DataWriting(BerDataNoCode, BerDataCode);
fprintf('\n*************\n');

end