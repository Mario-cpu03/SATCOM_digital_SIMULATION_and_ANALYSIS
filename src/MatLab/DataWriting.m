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
% meanBER, meanPER, SNRpercomm, meanAWGN_POWER, meanUP_LOSS, meanDOWN_LOSS,
% meanTEMPERATURE, meanWV_DENSITY, meanUP_THERMAL_POWER, meanDW_THERMAL_POWER.

function[] = DataWriting(BERnc, BERcc, PERnc, PERcc, ...
                         AWGNnc, AWGNcc, ATMUPnc, ATMUPcc, ATMDWnc, ATMDWcc, ...
                         TEMPnc, TEMPcc, DENnc, DENcc, THUPnc, THUPcc, ...
                         THDWnc, THDWcc, SNRnc, SNRcc)
%% Results Matrices Construcion 

Resultnc = [BERnc, PERnc, SNRnc, AWGNnc, ATMUPnc, ATMDWnc, TEMPnc, DENnc, THUPnc, THDWnc];
Resultcc = [BERcc, PERcc, SNRcc, AWGNcc, ATMUPcc, ATMDWcc, TEMPcc, DENcc, THUPcc, THDWcc];


%% Data Structure and init

headerscc = {'meanBER_cc', 'meanPER_cc', 'SNRpercomm_cc', 'meanAWGN_POWER_cc', 'meanUP_LOSS_cc', 'meanDOWN_LOSS_cc', 'meanTEMPERATURE_cc', 'meanWV_DENSITY_cc', 'meanUP_THERMAL_POWER_cc', 'meanDW_THERMAL_POWER_cc'};
headersnc = {'meanBER_nc', 'meanPER_nc', 'SNRpercomm_nc', 'meanAWGN_POWER_nc', 'meanUP_LOSS_nc', 'meanDOWN_LOSS_nc', 'meanTEMPERATURE_nc', 'meanWV_DENSITY_nc', 'meanUP_THERMAL_POWER_nc', 'meanDW_THERMAL_POWER_nc'};
filepathnc = '../../data/DataSet_RAW_noCode.csv';
filepathcc = '../../data/DataSet_RAW_ConvCode.csv';


%% Writing first dataset

fid = fopen(filepathnc, 'w');
fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n', headersnc{:});
fclose(fid);
dlmwrite(filepathnc, Resultnc, '-append');


%% Writing second dataset

fid = fopen(filepathcc, 'w');
fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n', headerscc{:});
fclose(fid);
dlmwrite(filepathcc, Resultcc, '-append');
end