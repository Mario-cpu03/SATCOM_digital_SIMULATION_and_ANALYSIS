%%% ChannelCod Script

%% The script ChannelCod.m is responsible for the BER and throughput evaluation 
% on a Convolutional coded channel.

% A coding rate of 1/2 will be used — the bare minimum — given the assumption
% of non-critical communications.
% In accordance with the MIL-STD-188 standard, for a rate 1/2 convolutional code, 
% we adopt a constraint length of 3, meaning that the encoder retains the last 
% 3 bits of input.
% Two generator polynomials, 7 and 5 (in octal), will be used accordingly.

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

function [BER, THROUGHPUT, PER, AWGN, ATMLOSSup, ATMLOSSdw, TEMPERATURE, DENSITY, THERMALNOISE] = ChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck)
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

% Coding parameters
constraintLength = 3;
trellis = poly2trellis(constraintLength, [7 5]);
%tracebackLength= 5*constraintLength;

% Performance Parameters init
BER = zeros(MonteCarlo,1); THROUGHPUT = zeros(MonteCarlo,1); PER = zeros(MonteCarlo,1);

% Other Parameters init
AWGN = zeros(MonteCarlo,1); ATMLOSSup = zeros(MonteCarlo,1); ATMLOSSdw = zeros(MonteCarlo,1);
TEMPERATURE = zeros(MonteCarlo,1); DENSITY = zeros(MonteCarlo,1); THERMALNOISE = zeros(MonteCarlo,1);

for (i = 1:MonteCarlo)
    
    %%Messages random generation:
    NotCodedCommand = randi([0,1],1,BitTx); 
    NotCodedAnswer = randi([0,1],1,BitRx);
    NotCodedAck = randi([0,1],1,BitAck);
    

    %%SNR Random generation for medium-optimal conditions
    % We'll assume that through the whole communication process (set of 3 messages
    % sent and received by the terrestrial nodes) a pre-setted SNR will be
    % guaranteed
    SNRs = unifrnd(5, 25);


    %%Coding and Modulation
    Command = convenc(NotCodedCommand, trellis);
    Answer = convenc(NotCodedAnswer, trellis); 
    Ack = convenc(NotCodedAck, trellis);

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
    PNoiseC = mean(abs(ThermalNoiseC).^2);
    ThermalNoiseAns = NoiseStd * (randn(1, NANS) + 1i*randn(1, NANS)) / sqrt(2);
    PNoiseAns = mean(abs(ThermalNoiseAns).^2);
    ThermalNoiseAck = NoiseStd * (randn(1, NACK) + 1i*randn(1, NACK)) / sqrt(2);
    PNoiseAck = mean(abs(ThermalNoiseAck).^2);

    % Loss Node->Sat in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lsend = gaspl(range,freqsend,T,P,Den);
    PReceivedSat1 = Ptrans * 10^(Gter/10) * 10^(Gsat/10)* 10^(-(Lsend/10));
    Pawgn1=PReceivedSat1/(10^(SNRs/10))-PNoiseC;
    NoiseAwgn1=sqrt(Pawgn1/2) * (randn(1,NC) + 1i*randn(1,NC));

    % Loss Node->Sat in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lsend = gaspl(range,freqsend,T,P,Den);
    PReceivedSat2 = Ptrans * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lsend/10));
    Pawgn2=PReceivedSat2/(10^(SNRs/10))-PNoiseAns;
    NoiseAwgn2=sqrt(Pawgn2/2) * (randn(1,NANS) + 1i*randn(1,NANS));

    % Loss Node->Sat in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lsend = gaspl(range,freqsend,T,P,Den);
    PReceivedSat3 = Ptrans * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lsend/10));
    Pawgn3=PReceivedSat3/(10^(SNRs/10))-PNoiseAck;
    NoiseAwgn3=sqrt(Pawgn3/2) * (randn(1,NACK) + 1i*randn(1,NACK));

    % Loss + Noise on signals Sat
    modSignalCommandSat = sqrt(PReceivedSat1)*modSignalCommand + NoiseAwgn1;
    modSignalAnswerSat = sqrt(PReceivedSat2)*modSignalAnswer + NoiseAwgn2;
    modSignalAckSat = sqrt(PReceivedSat3)*modSignalAck + NoiseAwgn3;


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
    PawgnBack1=PReceivedNode1/(10^(SNRs/10))-PNoiseC;
    NoiseAwgnBack1=sqrt(PawgnBack1/2) * (randn(1,NC) + 1i*randn(1,NC));

    % Loss Sat->Node in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lback = gaspl(range,freqback,T,P,Den);
    PReceivedNode2 = PTransSat2 * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lback/10));
    PawgnBack2=PReceivedNode2/(10^(SNRs/10))-PNoiseAns;
    NoiseAwgnBack2=sqrt(PawgnBack2/2) * (randn(1,NANS) + 1i*randn(1,NANS));

    % Loss Sat->Node in dB
    T = unifrnd(270,310); 
    RU = unifrnd(0,1);
    SatP = P0 * exp(L / R * (1 / T0 - 1 / T));
    Den = (RU * SatP) / (R * T);
    Lback = gaspl(range,freqback,T,P,Den);
    PReceivedNode3 = PTransSat3 * 10^(Gter/10) * 10^(Gsat/10) * 10^(-(Lback/10));
    PawgnBack3=PReceivedNode3/(10^(SNRs/10))-PNoiseAck;
    NoiseAwgnBack3=sqrt(PawgnBack3/2) * (randn(1,NACK) + 1i*randn(1,NACK));

    % Loss + Noise on signals Node
    modSignalCommandNode = sqrt(PReceivedNode1)*modSignalCommandSat + NoiseAwgnBack1;
    modSignalAnswerNode = sqrt(PReceivedNode2)*modSignalAnswerSat + NoiseAwgnBack2;
    modSignalAckNode = sqrt(PReceivedNode3)*modSignalAckSat + NoiseAwgnBack3;
  

    %%Demodulation, Decoding and choice (minimum distance)
    demodSignalCommandCoded = pskdemod(modSignalCommandNode,4,pi/4); 
    demodSignalAnswerCoded = pskdemod(modSignalAnswerNode,4,pi/4);
    demodSignalAckCoded = pskdemod(modSignalAckNode,4,pi/4);
    
    % AN ALTERNATIVE VERSION OF DECODING CAN BE EXECUTED UNCOMMENTING THE
    % FOLLOWING THREE LINES AND COMMENTING LINES 244-246.
    %demodSignalCommand = vitdec(demodSignalCommandCoded, trellis, tracebackLength, 'hard', 'trunc');
    %demodSignalAnswer = vitdec(demodSignalAnswerCoded, trellis, tracebackLength, 'hard', 'trunc');
    %demodSignalAck = vitdec(demodSignalAckCoded, trellis, tracebackLength, 'hard', 'trunc');

    demodSignalCommand = viterbiDecodeCustom(demodSignalCommandCoded);
    demodSignalAnswer = viterbiDecodeCustom(demodSignalAnswerCoded);
    demodSignalAck = viterbiDecodeCustom(demodSignalAckCoded);
    
    %---------------------------------------------------------------------%

    
    %%Evaluating performance
    % Meaned BER
    BER(i) = (sum(NotCodedCommand ~= demodSignalCommand) + sum(NotCodedAnswer ~= demodSignalAnswer) + sum(NotCodedAck ~= demodSignalAck)) / ...
             (length(NotCodedCommand) + length(NotCodedAnswer) + length(NotCodedAck));

    % Meaned THROUGHPUT
    correctBits = length(NotCodedCommand) - sum(NotCodedCommand ~= demodSignalCommand) + ...
                  length(NotCodedAnswer) - sum(NotCodedAnswer ~= demodSignalAnswer) + ...
                  length(NotCodedAck) - sum(NotCodedAck ~= demodSignalAck);
    THROUGHPUT(i) = correctBits / (length(NotCodedCommand) + length(NotCodedAnswer) + length(NotCodedAck));

    % Meaned PER
    PERcommand = any(NotCodedCommand ~= demodSignalCommand);
    PERanswer = any(NotCodedAnswer ~= demodSignalAnswer);
    PERack = any(NotCodedAck ~= demodSignalAck);

    PER(i,:) = (PERcommand + PERanswer + PERack)/NumMessages;

end

end


function decodedBits = viterbiDecodeCustom(receivedBits)
    % Parametri del codificatore
    k = 1; % bit input
    n = 2; % bit output
    constraintLength = 3;
    numStates = 2^(constraintLength - 1);
    
    % Trellis
    trellis = poly2trellis(constraintLength, [7 5]); % standard MIL-STD-188
    
    % Numero di simboli
    numInputBits = length(receivedBits) / n;
    
    % Inizializzazione metriche e path
    pathMetric = inf(numStates, numInputBits+1);
    pathMetric(1,1) = 0;
    path = zeros(numStates, numInputBits);

    % Decodifica passo-passo
    for t = 1:numInputBits
        receivedSymbol = receivedBits((t-1)*n+1 : t*n);

        for state = 0:numStates-1
            for inputBit = 0:1
                prevState = trellis.nextStates(state+1, inputBit+1);
                expectedOutput = de2bi(trellis.outputs(state+1, inputBit+1), n, 'left-msb');

                % Calcola distanza di Hamming (hard decision)
                hammingDist = sum(xor(receivedSymbol, expectedOutput));

                % Aggiorna metrica se più bassa
                if pathMetric(state+1, t) + hammingDist < pathMetric(prevState+1, t+1)
                    pathMetric(prevState+1, t+1) = pathMetric(state+1, t) + hammingDist;
                    path(prevState+1, t) = state;
                end
            end
        end
    end

    % Backtracking per trovare il path migliore
    decodedBits = zeros(1, numInputBits);
    [~, state] = min(pathMetric(:, end));

    for t = numInputBits:-1:1
        prevState = path(state, t);
        for inputBit = 0:1
            if trellis.nextStates(prevState+1, inputBit+1) == state - 1
                decodedBits(t) = inputBit;
                break;
            end
        end
        state = prevState + 1;
    end
end