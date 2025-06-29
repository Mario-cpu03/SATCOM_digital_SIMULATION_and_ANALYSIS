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

% Transmissive Power per Link will be fixed, according to MIL-STD-188 
% protocol, and its value will be the median between 1W and 50W: 25W.

% Frequency Band choice, one more time accordingly with the chosen
% protocol, is an SHF X-band (10GHz uplink and 8GHz downlink)

% System's performance will be evaluated using mostly BER and effective
% Throughput. Other performance parameters will be PER and SNR, but their
% role will be a marginal one.

function [] = Main(MonteCarlo)
%% Init Parameters

NumMessages = 3;
BitTx = 512; BitRx = 256; BitAck = 8;


%% Start Simulation without Convolution Coding

fprintf('\n*************\n');
[BERNoCode, THROUGHPUTNoCode, PERNoCode] = NoChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck);
%disp(transpose(BERNoCode)); disp(transpose(THROUGHPUTNoCode)); %disp(PERNoCode);
disp(mean(BERNoCode)); disp(mean(THROUGHPUTNoCode));
fprintf('\n*************\n');


%% Start Simulation with Convolution Coding

fprintf('\n*************\n');
%[BERCode, THROUGHPUTCode, PERCode] = ChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck);
fprintf('\n*************\n');


%% Data Persistence Logic

fprintf('\n*************\n');
%DataWriting(BerDataNoCode, BerDataCode);
fprintf('\n*************\n');

end