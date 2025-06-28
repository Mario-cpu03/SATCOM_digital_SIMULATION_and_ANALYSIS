%%% NoChannelCod Script

%% The script NoChannelCod.m is responsible for the BER and throughput evaluation
% on a non coded channel. 

% This analysis will be conducted to better comprehend Convolutional Coding
% strategies effect on the system's performance comparing its results with 
% the ones produced by a coded channel.

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

% The channel is not a lossless one, in fact AWGN, Thermal Noise and
% Atmospheric Attenuation will be summed up on the transmitted signal.

function [BER, THROUGHPUT, PER, SNR] = NoChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck)
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


%% Thermal Noise construction

% Boltzmann Constant
k = 1.38e-23;
% Kelvin Temperature
Temp = 290;
% Channel band uplink
Bup = 10e9; 
% Channel band downlink
Bdw = 8e9;
% Noise Power uplink
PnUp = k * Temp * Bup;   
% Noise Power downlink
PnDw = k * Temp * Bdw;


%% MonteCarlo times communication simulation

% Transimission Power in Watt
Ptrans = 25;

% Gain satellite antenna in dBi
Gsat = 30;

% Gain terrestrial military bases in dBi
Gter = 40;

% Performance Parameters init
BER = zeros(MonteCarlo,1); THROUGHPUT = zeros(MonteCarlo,1); 
PER = zeros(MonteCarlo,1); SNR = zeros(MonteCarlo,1);


for (i = 1:MonteCarlo)

    %%Messages random generation:
    Command = randi([0,1],1,BitTx); 
    Answer = randi([0,1],1,BitRx);
    Ack = randi([0,1],1,BitAck);
    

    %%Modulation
    modSignalCommand = pskmod(Command,4);
    modSignalAnswer = pskmod(Answer,4);
    modSignalAck = pskmod(Ack,4);


    %%Transmission on the channel towards the satellite
    NC = length(modSignalCommand);
    NANS = length(modSignalAnswer);
    NACK = length(modSignalAck);
    NoiseStd = sqrt(PnUp);   

    % Thermal Noise Node->Sat
    ThermalNoiseC = NoiseStd * (randn(1, NC) + 1i*randn(1, NC)) / sqrt(2);
    PNoiseC = mean(abs(ThermalNoiseC).^2);
    ThermalNoiseAns = NoiseStd * (randn(1, NANS) + 1i*randn(1, NANS)) / sqrt(2);
    PNoiseAns = mean(abs(ThermalNoiseAns).^2);
    ThermalNoiseAck = NoiseStd * (randn(1, NACK) + 1i*randn(1, NACK)) / sqrt(2);
    PNoiseAck = mean(abs(ThermalNoiseAck).^2);

    % SNR received without AWGN
    % Loss Node->Sat in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lsend = gaspl(range,freqsend,T,P,Den);
    PReceivedSat1 = Ptrans * 10^(Gter/10) * 10^(Gsat/10)* 10^(-(Lsend/10));
    SNRlinear1 = PReceivedSat1/PNoiseC;
    SNRc=10*log10(SNRlinear1);

    % Loss Node->Sat in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lsend = gaspl(range,freqsend,T,P,Den);
    PReceivedSat2 = Ptrans * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lsend/10));
    SNRlinear2 = PReceivedSat2/PNoiseAns;
    SNRans=10*log10(SNRlinear2);

    % Loss Node->Sat in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lsend = gaspl(range,freqsend,T,P,Den);
    PReceivedSat3 = Ptrans * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lsend/10));
    SNRlinear3 = PReceivedSat3/PNoiseAck;
    SNRack=10*log10(SNRlinear3);

    % Loss + Noise on signals Sat
    modSignalCommandSat = awgn(modSignalCommand, SNRc, "measured");
    modSignalAnswerSat = awgn(modSignalAnswer, SNRans, "measured");
    modSignalAckSat = awgn(modSignalAck, SNRack, "measured");


    %%Satellite Relay amplification
    PTransSat1 = PReceivedSat1 * 10^(Gsat/10);
    PTransSat2 = PReceivedSat2 * 10^(Gsat/10);
    PTransSat3 = PReceivedSat3 * 10^(Gsat/10);
    %disp(PTransSat1); disp(PTransSat2); disp(PTransSat3); %PRINT TO CHECK


    %---------------------------------------------------------------------%


    %%Receiving Signals on Earth
    
    % Thermal Noise Sat->Node
    NoiseStd = sqrt(PnDw);
    ThermalNoiseC = NoiseStd * (randn(1, NC) + 1i*randn(1, NC)) / sqrt(2);
    PNoiseC = mean(abs(ThermalNoiseC).^2);
    ThermalNoiseAns = NoiseStd * (randn(1, NANS) + 1i*randn(1, NANS)) / sqrt(2);
    PNoiseAns = mean(abs(ThermalNoiseAns).^2);
    ThermalNoiseAck = NoiseStd * (randn(1, NACK) + 1i*randn(1, NACK)) / sqrt(2);
    PNoiseAck = mean(abs(ThermalNoiseAck).^2);

    % SNR received without AWGN
    % Loss Sat->Node in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lback = gaspl(range,freqback,T,P,Den);
    PReceivedNode1 = PTransSat1 * 10^(Gter/10) * 10^(Gsat/10)* 10^(-(Lback/10));
    SNRlinear1back = PReceivedNode1/PNoiseC;
    SNRc=10*log10(SNRlinear1back);

    % Loss Sat->Node in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lback = gaspl(range,freqback,T,P,Den);
    PReceivedNode2 = PTransSat2 * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lback/10));
    SNRlinear2back = PReceivedNode2/PNoiseAns;
    SNRans=10*log10(SNRlinear2back);

    % Loss Sat->Node in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lback = gaspl(range,freqback,T,P,Den);
    PReceivedNode3 = PTransSat3 * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lback/10));
    SNRlinear3back = PReceivedNode3/PNoiseAck;
    SNRack=10*log10(SNRlinear3back);

    % Loss + Noise on signals Node
    modSignalCommandNode = awgn(modSignalCommandSat, SNRc, "measured");
    modSignalAnswerNode = awgn(modSignalAnswerSat, SNRans, "measured");
    modSignalAckNode = awgn(modSignalAckSat, SNRack, "measured");


    %%Demodulation and choice (minimum distance)

    demodSignalCommand = pskdemod(modSignalCommandNode,4); 
    demodSignalAnswer = pskdemod(modSignalAnswerNode,4);
    demodSignalAck = pskdemod(modSignalAckNode,4);


    %---------------------------------------------------------------------%
    
    
    %%Evaluating performance

    % Meaned BER
    BERcommand = sum(Command ~= demodSignalCommand) / length(Command);
    BERanswer = sum(Answer ~= demodSignalAnswer) / length(Answer);
    BERack = sum(Ack ~= demodSignalAck) / length(Ack);

    BER(i, :) = (BERcommand + BERanswer + BERack)/NumMessages;

    % Meaned THROUGHPUT
    correctBitsCommand = length(Command) - sum(Command ~= demodSignalCommand);
    correctBitsAnswer = length(Answer) - sum(Answer ~= demodSignalAnswer);
    correctBitsAck = length(Ack) - sum(Ack ~= demodSignalAck);

    THROUGHPUT(i,:) = (correctBitsCommand + correctBitsAnswer + correctBitsAck)/(length(Command) + length(Answer) + length(Ack));

    % Meaned PER
    PERcommand = any(Command ~= demodSignalCommand);
    PERanswer = any(Answer ~= demodSignalAnswer);
    PERack = any(Ack ~= demodSignalAck);

    PER(i,:) = (PERcommand + PERanswer + PERack)/NumMessages;

    % Meaned SNR
    SNR(i,:) = (SNRc + SNRans + SNRack)/NumMessages;

end

end