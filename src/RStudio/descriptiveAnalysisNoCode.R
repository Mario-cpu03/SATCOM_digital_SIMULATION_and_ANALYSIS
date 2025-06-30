### Descriptive Analysis Script (non-coded data)

# The descriptiveAnalysisNoCode script is used to define
# and analyze all the variables in the NoCode training set
# using descriptive statistic methods. The final goal is to
# evaluate distributions by defyning pivotal quantities and
# sampled moments of the variables.

# A set of graphical and textual results, that can be found in the "../../results/" directory,
# will be produced, as an output of both this and the "descriptiveAnalysisCode.R" script,

# The following script will be useful and necessary to the correlation analysis phase.

## EXPLORATION

sDS <- capture.output(psych::describe(dataRawNoCode))
summaryDataSet <- c("Summary of the non-processed non-coded channel Data Set:\n",
                    sDS, "\n",
                    "Dimension: ", dim(dataRawNoCode))
writeLines(summaryDataSet, "../../results/CharacterizedDataSet_noCode.txt")
# Strong skewness on BER, THROUGHPUT, PER and AWGN Power.
# Moderate skewness on both Up and Down THERMAL Power.
# Minor skewness on other parameters.

# Sensibly high Kurtosis values on BER, THROUGHPUT and AWGN Power.

# Platikurtic distributions on every other parameter.

# Note that the emerged skewness must be reduced with appropriate transformations.
# Moreover, a boxplot graphic evaluation is necessary in order to
# check for non-good outliers, especially on leptokurtic distributions such as:
# BER, THROUGHPUT and AWGN Power.

## GRAPHIC EVALUATION

for (i in 1:11) {
  png(filename = paste0("../../results/boxplots/box_nc/", "boxplot_", names(dataRawNoCode)[i], ".png"))
  boxplot(dataRawNoCode[, i], main = names(dataRawNoCode)[i])
  dev.off()
}
# Clearly problematic outliers. 
# logit(x) transformation needed on BER and THROUGHPUT (values always between 0 and 1)
# log(x + epsilon) transformation needed on AWGN (non limited values)

# New meanBER_nc
logitBER_nc <- log(dataRawNoCode$meanBER_nc / (1 - dataRawNoCode$meanBER_nc))
png(filename = paste0("../../results/boxplots/box_nc/", "boxplot_logitBER_nc.png"))
boxplot(logitBER_nc, main = "logitBER_nc")
dev.off()

# New meanTHROUGHPUT_nc
logitTHROUGHPUT_nc <- log(dataRawNoCode$meanTRHOUGHPUT_nc / (1 - dataRawNoCode$meanTRHOUGHPUT_nc))
png(filename = paste0("../../results/boxplots/box_nc/", "boxplot_logitTHROUGHPUT_nc.png"))
boxplot(logitTHROUGHPUT_nc, main = "logitTHROUGHPUT_nc")
dev.off()

# New meanAWGN_POWER_nc
epsilon <- min(dataRawNoCode$meanAWGN_POWER_nc[dataRawNoCode$meanAWGN_POWER_nc>0])*0.01
logAWGN_POWER_nc <- log(dataRawNoCode$meanAWGN_POWER_nc + epsilon)
png(filename = paste0("../../results/boxplots/box_nc/", "boxplot_logAWGN_POWER_nc.png"))
boxplot(logAWGN_POWER_nc, main = "logAWGN_POWER_nc")
dev.off()

