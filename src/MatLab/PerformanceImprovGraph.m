%%% PerformanceImprovGraph Script

%% Performance Comparison Script
% This script evaluates the improvements introduced by convolutional coding 
% in terms of key performance metrics: BER, PER, and Throughput.
% It generates a comparative plot between the uncoded and convolutionally 
% coded transmission scenarios, highlighting the benefits of error correction.

% This is to intend as a preliminar data analysis that should justify the
% implementation of a coded channel.

% A persistence logic will be developed such that resulting png(s) will be
% saved in a dedicated directory ("../../results/cc-nc_COMPARISON/").

% Moreover, a .txt file containing MonteCarlo meaned values of SNR,
% Atmospheric Loss (Up and Down) and all of the other output parametrs of
% ChannelCod.m and NoChannelCod.m files.

function [] = PerformanceImprovGraph(BERnc, BERcc, THRnc, THRcc, PERnc, PERcc, ...
                                     AWGNnc, AWGNcc, ATMUPnc, ATMUPcc, ATMDWnc, ATMDWcc, ...
                                     TEMPnc, TEMPcc, DENnc, DENcc, THUPnc, THUPcc, ...
                                     THDWnc, THDWcc, SNRnc, SNRcc)
%% BER plot

f1 = figure;
bar([BERnc, BERcc], 0.4);
set(gca, 'XTickLabel', {'Non Coded', 'Coded'});
title('Bit Error Rate (BER)');
ylabel('BER');
grid on;
ylim([0 max([BERnc, BERcc])*1.1]);


%% Throughput plot

f2 = figure;
bar([THRnc, THRcc], 0.4);
set(gca, 'XTickLabel', {'Non Coded', 'Coded'});
title('Effective Throughput');
ylabel('Throughput');
grid on;
ylim([0 1]);


%% PER plot

f3 = figure;
bar([PERnc, PERcc], 0.4);
set(gca, 'XTickLabel', {'Non Coded', 'Coded'});
title('Packet Error Rate (PER)');
ylabel('PER');
grid on;
ylim([0 max([PERnc, PERcc])*1.1]);


%% Data Persistence Logic

% graphs
saveas(f1, '../../results/cc-nc_COMPARISON/BER_Improvements.png');
saveas(f2, '../../results/cc-nc_COMPARISON/THROUGHPUT_Improvements.png');
saveas(f3, '../../results/cc-nc_COMPARISON/PER_Improvements.png');

% txt file
fid = fopen('../../results/cc-nc_COMPARISON/Mean-Parameters_COMPARISON.txt', 'w');
fprintf(fid, ['Summary of the simulated results.\nPlease note that the following values represent the average performance of the system, ' ...
              'computed over all MonteCarlo iterations. Each iteration simulates the exchange ' ...
              'of three messages, both with and without convolutional coding -respectively in Sim. 1 and Sim. 2- to provide a robust ' ...
              'estimate of the system’s average behavior under varying conditions.\n\n']);

fprintf(fid, 'Sim. 1 - No Convolutional Coding Techniques:\n');
fprintf(fid, 'BER:%.6f\n', BERnc); fprintf(fid, 'Effective Throughput:%.6f\n', THRnc); fprintf(fid, 'PER:%.6f\n', BERnc);
fprintf(fid, 'SNR in dB:%.6f\n', SNRnc); fprintf(fid, 'AWGN Power:%.6f\n', AWGNnc); fprintf(fid, 'Uplink Thermal Noise Power:%.15f\n', THUPnc);
fprintf(fid, 'Down Thermal Noise Power:%.15f\n', THDWnc); fprintf(fid, 'Atmospheric Temperature:%.15f\n', TEMPnc); 
fprintf(fid, 'Water Vapor Density:%.6f\n', DENnc); fprintf(fid, 'Uplink Atmospheric Attenuation:%.6f\n', ATMUPnc); 
fprintf(fid, 'Downlink Atmospheric Attenuation:%.6f\n', ATMDWnc);
fprintf(fid, '\n');

fprintf(fid, '\nSim. 2 - Convolutional Coding Techniques:\n');
fprintf(fid, 'BER:%.6f\n', BERcc); fprintf(fid, 'Effective Throughput:%.6f\n', THRcc); fprintf(fid, 'PER:%.6f\n', BERcc);
fprintf(fid, 'SNR in dB:%.6f\n', SNRcc); fprintf(fid, 'AWGN Power:%.6f\n', AWGNcc);  fprintf(fid, 'Uplink Thermal Noise Power:%.15f\n', THUPcc);
fprintf(fid, 'Down Thermal Noise Power:%.15f\n', THDWcc); fprintf(fid, 'Atmospheric Temperature:%.6f\n', TEMPcc); 
fprintf(fid, 'Water Vapor Density:%.6f\n', DENcc); fprintf(fid, 'Uplink Atmospheric Attenuation:%.6f\n', ATMUPcc); 
fprintf(fid, 'Downlink Atmospheric Attenuation:%.6f\n', ATMDWcc);
fprintf(fid, '\n');
fclose(fid);
end