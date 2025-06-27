%%% Main File

% The script Main.m is responsible for the execution of all the other
% scripts.
% It receivs MonteCarlo, NumMessages and BitPerMessage as input parameters.

% MonteCarlo is to intend as the cardinality of the results sample 
% (number of times the simulation is repeated)

% NumMessages is the number of application layer packets the transmitter
% node wants to send to the receiver

% BitPerMessage is the number of Bits every app layer packet is made
% up of. 

function [] = Main(MonteCarlo, NumMessages, BitPerMessage)

fprintf('\n*************\n');
PeDataNoCode = NoChannelCod(MonteCarlo, NumMessages, BitPerMessage);

fprintf('\n*************\n');
PeDataCode = ChannelCod(MonteCarlo, NumMessages, BitPerMessage);

fprintf('\n*************\n');
DataWriting(PeDataNoCode, PeDataCode);

end