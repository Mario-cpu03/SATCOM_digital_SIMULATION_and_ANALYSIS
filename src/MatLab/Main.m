%%% Main Script

%% The script Main.m is responsible for the execution of all the other
% scripts.
% It receivs just MonteCarlo as input parameter.
% MonteCarlo is to intend as the cardinality of the results sample 
% (number of times the simulation is repeated)

% Other relevant parameters are:

% "NumMessages" is the number of application layer packets the transmitter
% node wants to send to the receiver

% "Bit*" is the data dimension in bit for every message. We'll suppose a Tx text
% message of medium-low size (512 bit), an Rx state message of 256 bit and a
% 8 bit Tx Acknowledgement message.

% Data dimensions and Modulation schema (QPSK) are chosen as defined in the 
% MIL-STD-188 protocol.

% System's performance will be evaluated using BER and effective
% Throughput.

function [] = Main(MonteCarlo)

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