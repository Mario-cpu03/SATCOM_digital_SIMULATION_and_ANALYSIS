### Main Script

setwd("~/Desktop/MATlab/SATCOM_digital_SIMULATION_and_ANALYSIS/src/RStudio/");

dataRawNoCode <- read.csv("../../data/DataSet_RAW_noCode.csv")
dataRawCode <- read.csv("../../data/DataSet_RAW_ConvCode.csv")

## EXPLORATIVE ANALYSIS:

source("./dataPreprocessingNoCode.R")
source("./dataPreprocessingCode.R")
