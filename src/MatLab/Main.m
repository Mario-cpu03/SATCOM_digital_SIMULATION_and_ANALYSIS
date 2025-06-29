%%% Main Script

%% The script Main.m is responsible for the execution of all the other scripts.
% It takes as input a single parameter: MonteCarlo.
% "MonteCarlo" represents the number of independent communication simulations 
% to be executed, defining the size of the statistical sample.

% Other relevant parameters are:

% "NumMessages" is the number of full communication cycles between the two terrestrial nodes. "NumMessages": the number 
% Each communication is structured as follows: 
% - the Tx node sends a text message representing a command to the Rx node.
% - the Rx node replies with a status message (acknowledging success or failure).
% - the Tx node then sends an acknowledgment (Ack) to confirm message reception.

% The geostationary satellite is modeled as a passive relay, 
% meaning no amplification is performed onboard, and only antenna gains are 
% considered in the link budget.

% From now on, the term "communication" will refer to the process of
% transmitting all three messages and, in this context, will be used as
% a synonym for "simulation".

% "Bit*" is the data dimension in bit for every message. 
% We'll suppose a Tx text message of 512 bit (medium-low size), 
% an Rx state message of 256 bit and an 8 bit Tx Acknowledgement.

% Data dimensions and Modulation schema (QPSK) are chosen as defined in the 
% MIL-STD-188 protocol.

% Transmissive Power per Link will be fixed, according to MIL-STD-188 
% protocol, and its value will be the median between 1W and 50W: 25W.

% Frequency Band choice, one more time accordingly with the chosen
% protocol, is an SHF X-band (8.2GHz uplink and 7.5GHz downlink)

% System's performance will be evaluated using mostly BER (Bit Error Rate) 
% and Effective Throughput. 
% A secondary performance parameter will be PER (Packet Error Rate).

function [] = Main(MonteCarlo)
%% Init Parameters

NumMessages = 3;
BitTx = 512; BitRx = 256; BitAck = 8;


%% Start Simulation without Convolution Coding

fprintf('\n*************\n');
[BERNoCode, THROUGHPUTNoCode, PERNoCode] = NoChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck);
fprintf("\nMean BER on a non coded channel:"); disp(mean(BERNoCode));
fprintf("\nMean Effective Throughput on a non coded channel:"); disp(mean(THROUGHPUTNoCode));
fprintf("\nMean PER on a non coded channel:");  disp(mean(PERNoCode))
fprintf('\n*************\n');


%% Start Simulation with Convolution Coding

fprintf('\n*************\n');
[BERCode, THROUGHPUTCode, PERCode] = ChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck);
fprintf("\nMean BER on a convolutional coded channel:"); disp(mean(BERCode)); 
fprintf("\nMean Effective Throughput on a convolutional coded channel:"); disp(mean(THROUGHPUTCode)); 
fprintf("\nMean PER on a convolutional coded channel:"); disp(mean(PERCode))
fprintf('\n*************\n');


%% A simple Graphic evaluation

PerformanceImprovGraph(mean(BERNoCode), mean(BERCode) ...
    , mean(THROUGHPUTNoCode), mean(THROUGHPUTCode) ...
    , mean(PERNoCode), mean(PERCode));


%% Data Persistence Logic

fprintf('\n*************\n');
%DataWriting(BerDataNoCode, BerDataCode);
fprintf('\n*************\n');

end