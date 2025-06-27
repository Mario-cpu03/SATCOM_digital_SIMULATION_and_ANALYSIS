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

function [] = NoChannelCod(MonteCarlo, NumMessages, BitTx, BitRx, BitAck)


end