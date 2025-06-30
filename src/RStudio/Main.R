### Main Script

# The Main.R script is used to read and exec code from
# all the other "*.R" scripts that can be found in the 
# "SATCOM_digital_SIMULATION_and_ANALYSIS/src/RStudio/" directory.

# The training sets that are focal points of the following 
# examination may be found in the 
# "SATCOM_digital_SIMULATION_and_ANALYSIS/data/" directory

# Setting the correct working directory:
# delete the content of the following command and insert the correct
# local path to your working directory. 
# Comment the command in any other occasion.
setwd("~/Desktop/MATlab/SATCOM_digital_SIMULATION_and_ANALYSIS/src/RStudio/");

# Import data sets:
dataRawNoCode <- read.csv("../../data/DataSet_RAW_noCode.csv")
dataRawCode <- read.csv("../../data/DataSet_RAW_ConvCode.csv")


## EXPLORATIVE ANALYSIS:

source("./dataPreprocessingNoCode.R")
source("./dataPreprocessingCode.R")

source("./descriptiveAnalysisNoCode.R")
source("./descriptiveAnalysisCode.R")

source("./correlationAnalysisNoCode.R")
source("./correlationAnalysisCode.R")


## IMPORT OF THE PROCESSED DATA SETS:


## 
