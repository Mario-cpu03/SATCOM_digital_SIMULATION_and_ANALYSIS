%%% NoChannelCod Script

%% The script NoChannelCod.m is responsible for the system's performance evaluation
% on a non coded channel. 

% The purpose of this analysis is to establish a baseline for comparison 
% against convolutionally coded channels, in order to assess 
% the effectiveness of coding techniques.

% The proposed scenario is characterized by a fixed SNR per communication 
% and Ptrans (to be seen as the transmissive power of the terrestrial nodes)

% Weather conditions will follow the assumption of equiprobability, 
% in order to model different meteorological conditions without focusing 
% on the geolocation of the nodes or other parameters. These conditions 
% will be represented by the temperature "T", pressure "P", and atmospheric 
% water vapor density "Den".
% In this context, T and Den will be random variables strictly 
% correlated with the Atmospheric Attenuation (L). Note that this quantity 
% will vary depending on the considered link, due to the different carrier 
% frequencies.

% The channel is not ideal: thermal noise, atmospheric attenuation and AWGN
% are added to the transmitted signal.

% Note: Scintillation effects are neglected in this model.

function [BER, THROUGHPUT, PER, AWGN, ATMLOSSup, ATMLOSSdw, TEMPERATURE, DENSITY, THERMALNOISEup, THERMALNOISEdw, SNR] = NoChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck)
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
freqsend = 8.2e9;
freqback = 7.5e9;


%% Thermal Noise construction

% Boltzmann Constant
k = 1.38e-23;
% Kelvin Temperature
Temp = 290;
% Noise Power uplink
PnUp = k * Temp * freqsend;   
% Noise Power downlink
PnDw = k * Temp * freqback;


%% MonteCarlo times communication simulation

% Transimission Power in Watt
Ptrans = 25;

% Gain satellite antenna in dBi
Gsat = 30;

% Gain terrestrial military bases in dBi
Gter = 40;

% Performance Parameters init
BER = zeros(MonteCarlo,1); THROUGHPUT = zeros(MonteCarlo,1); PER = zeros(MonteCarlo,1);

% Other Parameters init
AWGN = zeros(MonteCarlo,1); ATMLOSSup = zeros(MonteCarlo,1); ATMLOSSdw = zeros(MonteCarlo,1); 
TEMPERATURE = zeros(MonteCarlo,1); DENSITY = zeros(MonteCarlo,1); THERMALNOISEup = zeros(MonteCarlo,1);
THERMALNOISEdw = zeros(MonteCarlo,1); SNR = zeros(MonteCarlo,1);

% Computing related parameters
Tvect = zeros(6,1); Denvect = zeros(6,1);

for (i = 1:MonteCarlo)

    %%Messages random generation:
    Command = randi([0,1],1,BitTx); 
    Answer = randi([0,1],1,BitRx);
    Ack = randi([0,1],1,BitAck);
    

    %%SNR Random generation for medium-optimal conditions
    % We'll assume that through the whole communication process (set of 3 messages
    % sent and received by the terrestrial nodes) a pre-setted SNR will be
    % guaranteed, both in Uplink and Downlink.
    SNRs = unifrnd(5, 25);


    %%Modulation
    modSignalCommand = pskmod(Command,4,pi/4);
    modSignalCommand = modSignalCommand / sqrt(mean(abs(modSignalCommand).^2));

    modSignalAnswer = pskmod(Answer,4,pi/4);
    modSignalAnswer = modSignalAnswer / sqrt(mean(abs(modSignalAnswer).^2));

    modSignalAck = pskmod(Ack,4,pi/4);
    modSignalAck = modSignalAck / sqrt(mean(abs(modSignalAck).^2));


    %%Transmission on the channel towards the satellite
    NC = length(modSignalCommand);
    NANS = length(modSignalAnswer);
    NACK = length(modSignalAck);
    NoiseStd = sqrt(PnUp);   

    % Thermal Noise Node->Sat
    ThermalNoiseC = NoiseStd * (randn(1, NC) + 1i*randn(1, NC)) / sqrt(2);
    PNoiseCup = mean(abs(ThermalNoiseC).^2);
    ThermalNoiseAns = NoiseStd * (randn(1, NANS) + 1i*randn(1, NANS)) / sqrt(2);
    PNoiseAnsup = mean(abs(ThermalNoiseAns).^2);
    ThermalNoiseAck = NoiseStd * (randn(1, NACK) + 1i*randn(1, NACK)) / sqrt(2);
    PNoiseAckup = mean(abs(ThermalNoiseAck).^2);

    % Loss Node->Sat in dB
    T = unifrnd(270,310); Tvect(1,:) = T;
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T); Denvect(1,:) = Den;
    Lsend1 = gaspl(range,freqsend,T,P,Den);
    PReceivedSat1 = Ptrans * 10^(Gter/10) * 10^(Gsat/10)* 10^(-(Lsend1/10));
    Pawgn1=PReceivedSat1/(10^(SNRs/10))-PNoiseCup;
    NoiseAwgn1=sqrt(Pawgn1/2) * (randn(1,NC) + 1i*randn(1,NC));

    % Loss Node->Sat in dB
    T = unifrnd(270,310); Tvect(2,:) = T;
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T); Denvect(2,:) = Den;
    Lsend2 = gaspl(range,freqsend,T,P,Den);
    PReceivedSat2 = Ptrans * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lsend2/10));
    Pawgn2=PReceivedSat2/(10^(SNRs/10))-PNoiseAnsup;
    NoiseAwgn2=sqrt(Pawgn2/2) * (randn(1,NANS) + 1i*randn(1,NANS));

    % Loss Node->Sat in dB
    T = unifrnd(270,310); Tvect(3,:) = T;
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T); Denvect(3,:) = Den;
    Lsend3 = gaspl(range,freqsend,T,P,Den);
    PReceivedSat3 = Ptrans * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lsend3/10));
    Pawgn3=PReceivedSat3/(10^(SNRs/10))-PNoiseAckup;
    NoiseAwgn3=sqrt(Pawgn3/2) * (randn(1,NACK) + 1i*randn(1,NACK));

    % Loss + Noise on signals Sat
    modSignalCommandSat = sqrt(PReceivedSat1)*modSignalCommand + NoiseAwgn1 + PNoiseCup;
    modSignalAnswerSat = sqrt(PReceivedSat2)*modSignalAnswer + NoiseAwgn2 + PNoiseAnsup;
    modSignalAckSat = sqrt(PReceivedSat3)*modSignalAck + NoiseAwgn3 + PNoiseAckup;


    %%Satellite Relay - it does not act as an Amplify and
    %%Forward, it acts as a passive relay.
    PTransSat1 = PReceivedSat1;
    PTransSat2 = PReceivedSat2;
    PTransSat3 = PReceivedSat3;
    %disp(PTransSat1); disp(PTransSat2); disp(PTransSat3); %PRINT TO CHECK


    %---------------------------------------------------------------------%


    %%Receiving Signals on Earth
    % Thermal Noise Sat->Node
    NoiseStd = sqrt(PnDw);
    ThermalNoiseC = NoiseStd * (randn(1, NC) + 1i*randn(1, NC)) / sqrt(2);
    PNoiseCdw = mean(abs(ThermalNoiseC).^2);
    ThermalNoiseAns = NoiseStd * (randn(1, NANS) + 1i*randn(1, NANS)) / sqrt(2);
    PNoiseAnsdw = mean(abs(ThermalNoiseAns).^2);
    ThermalNoiseAck = NoiseStd * (randn(1, NACK) + 1i*randn(1, NACK)) / sqrt(2);
    PNoiseAckdw = mean(abs(ThermalNoiseAck).^2);

    % SNR received without AWGN
    % Loss Sat->Node in dB
    T = unifrnd(270,310); Tvect(4,:) = T;
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T); Denvect(4,:) = Den;
    Lback1 = gaspl(range,freqback,T,P,Den);
    PReceivedNode1 = PTransSat1 * 10^(Gter/10) * 10^(Gsat/10)* 10^(-(Lback1/10));
    PawgnBack1=PReceivedNode1/(10^(SNRs/10))-PNoiseCdw;
    NoiseAwgnBack1=sqrt(PawgnBack1/2) * (randn(1,NC) + 1i*randn(1,NC));

    % Loss Sat->Node in dB
    T = unifrnd(270,310); Tvect(5,:) = T;
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T); Denvect(5,:) = Den;
    Lback2 = gaspl(range,freqback,T,P,Den);
    PReceivedNode2 = PTransSat2 * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lback2/10));
    PawgnBack2=PReceivedNode2/(10^(SNRs/10))-PNoiseAnsdw;
    NoiseAwgnBack2=sqrt(PawgnBack2/2) * (randn(1,NANS) + 1i*randn(1,NANS));

    % Loss Sat->Node in dB
    T = unifrnd(270,310); Tvect(6,:) = T;
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T); Denvect(6,:) = Den;
    Lback3 = gaspl(range,freqback,T,P,Den);
    PReceivedNode3 = PTransSat3 * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lback3/10));
    PawgnBack3=PReceivedNode3/(10^(SNRs/10))-PNoiseAckdw;
    NoiseAwgnBack3=sqrt(PawgnBack3/2) * (randn(1,NACK) + 1i*randn(1,NACK));

    % Loss + Noise on signals Node
    modSignalCommandNode = sqrt(PReceivedNode1)*modSignalCommandSat + NoiseAwgnBack1 + PNoiseCdw;
    modSignalAnswerNode = sqrt(PReceivedNode2)*modSignalAnswerSat + NoiseAwgnBack2 + PNoiseAnsdw;
    modSignalAckNode = sqrt(PReceivedNode3)*modSignalAckSat + NoiseAwgnBack3 + PNoiseAckdw;


    %%Demodulation and choice (minimum distance)
    demodSignalCommand = pskdemod(modSignalCommandNode,4,pi/4); 
    demodSignalAnswer = pskdemod(modSignalAnswerNode,4,pi/4);
    demodSignalAck = pskdemod(modSignalAckNode,4,pi/4);


    %---------------------------------------------------------------------%

    
    %%Evaluating performance
    % Meaned BER
    BER(i) = (sum(Command ~= demodSignalCommand) + sum(Answer ~= demodSignalAnswer) + sum(Ack ~= demodSignalAck)) / ...
             (length(Command) + length(Answer) + length(Ack));

    % Meaned THROUGHPUT
    correctBits = length(Command) - sum(Command ~= demodSignalCommand) + ...
                  length(Answer) - sum(Answer ~= demodSignalAnswer) + ...
                  length(Ack) - sum(Ack ~= demodSignalAck);
    THROUGHPUT(i) = correctBits / (length(Command) + length(Answer) + length(Ack));

    % Meaned PER
    PERcommand = any(Command ~= demodSignalCommand);
    PERanswer = any(Answer ~= demodSignalAnswer);
    PERack = any(Ack ~= demodSignalAck);

    PER(i,:) = (PERcommand + PERanswer + PERack)/NumMessages;

    % Meaned AWGN power
    AWGN(i,:) = (Pawgn1 + Pawgn2 + Pawgn3 + ...
                PawgnBack1 + PawgnBack2 + PawgnBack3)...
                /(2*NumMessages);

    % Meaned ATMLOSS uplink
    ATMLOSSup(i,:) = (Lsend1 + Lsend2 + Lsend3)/NumMessages;

    % Meaned ATMLOSS downlink
    ATMLOSSdw(i,:) = (Lback1 + Lback2 + Lback3)/NumMessages;

    % Meaned THERMALNOISE power Uplink
    THERMALNOISEup(i,:) = (PNoiseCup + PNoiseAnsup + PNoiseAckup)/NumMessages;

    % Meaned THERMALNOISE power Downlink
    THERMALNOISEdw(i,:) = (PNoiseCdw + PNoiseAnsdw + PNoiseAckdw)/NumMessages;

    % SNR per communication
    SNR(i,:) = SNRs;

    % Meaned TEMPERATURE 
    TEMPERATURE(i,:) = mean(Tvect);

    % Meaned water vapor DENSITY
    DENSITY(i,:) = mean(Denvect);

end

end