%%% PerformanceImprovGraph Script

%% Performance Comparison Script
% This script evaluates the improvements introduced by convolutional coding 
% in terms of key performance metrics: BER, PER, and Throughput.
% It generates a comparative plot between the uncoded and convolutionally 
% coded transmission scenarios, highlighting the benefits of error correction.

% This is to intend as a preliminar data analysis that should justify the
% implementation of a coded channel.

% A persistence logic will be developed such that resulting png(s) will be
% saved in a dedicated directory ("../../results/"). 

function [] = PerformanceImprovGraph(BERnc, BERcc, THRnc, THRcc, PERnc, PERcc)
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

saveas(f1, '../../results/BER_Improvements.png');
saveas(f2, '../../results/THROUGHPUT_Improvements.png');
saveas(f3, '../../results/PER_Improvements.png');

end