%%% Data Wirting Script

%% The script DataWriting.m is responsible for the data persistence logic 
% implementation. 

% Two .csv files will be produced as the ouput, ready for an RStudio 
% statistical analysis (visit "../RStudio/" to see source code 
% or "../../results/" and "../../docs/" to see the final results and report)

% The first dataset will contain data of the Non coded
% transmissions, while the second one will contain data produced by 
% the Convolution Coded simulation.

% Each dataset will have the structure that follows:
% meanBER, meanTRHOUGHPUT, meanPER, SNRpercomm, meanAWGN_POWER, meanUP_LOSS, meanDOWN_LOSS,
% meanTEMPERATURE, meanWV_DENSITY, meanUP_THERMAL_POWER, meanDW_THERMAL_POWER.

function[] = DataWriting(BERnc, BERcc, THRnc, THRcc, PERnc, PERcc, ...
                         AWGNnc, AWGNcc, ATMUPnc, ATMUPcc, ATMDWnc, ATMDWcc, ...
                         TEMPnc, TEMPcc, DENnc, DENcc, THUPnc, THUPcc, ...
                         THDWnc, THDWcc, SNRnc, SNRcc)
%% Results Matrices Construcion 

Resultnc = [BERnc, THRnc, PERnc, SNRnc, AWGNnc, ATMUPnc, ATMDWnc, TEMPnc, DENnc, THUPnc, THDWnc];
Resultcc = [BERcc, THRcc, PERcc, SNRcc, AWGNcc, ATMUPcc, ATMDWcc, TEMPcc, DENcc, THUPcc, THDWcc];


%% Data Structure and init

headers = {'meanBER', 'meanTRHOUGHPUT', 'meanPER', 'SNRpercomm', 'meanAWGN_POWER', 'meanUP_LOSS', 'meanDOWN_LOSS', 'meanTEMPERATURE', 'meanWV_DENSITY', 'meanUP_THERMAL_POWER', 'meanDW_THERMAL_POWER'};
filepathnc = '../../data/DataSet_RAW_noCode.csv';
filepathcc = '../../data/DataSet_RAW_ConvCode.csv';


%% Writing first dataset

fid = fopen(filepathnc, 'w');
fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n', headers{:});
fclose(fid);
dlmwrite(filepathnc, Resultnc, '-append');


%% Writing second dataset

fid = fopen(filepathcc, 'w');
fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n', headers{:});
fclose(fid);
dlmwrite(filepathcc, Resultcc, '-append');
end