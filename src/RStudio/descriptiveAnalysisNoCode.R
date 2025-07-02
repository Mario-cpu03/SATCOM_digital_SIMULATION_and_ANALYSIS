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
# Strong skewness observed in BER, PER, and AWGN Power.
# Moderate skewness present in both Uplink and Downlink Thermal Noise Power.
# Minor skewness detected in the remaining parameters.

# Significantly high kurtosis values in BER, and AWGN Power,
# indicating heavy-tailed distributions.

# Platykurtic behavior observed in all other variables.

# The identified skewness should be addressed with appropriate transformations 
# to improve distribution symmetry and modeling suitability.
# Additionally, boxplot visualizations are recommended to assess potential 
# outliers, particularly within leptokurtic distributions such as BER, and AWGN Power.


## GRAPHIC EVALUATION

for (i in 1:10) {
  png(filename = paste0("../../results/boxplots/box_nc/", "boxplot_", names(dataRawNoCode)[i], ".png"))
  boxplot(dataRawNoCode[, i], main = names(dataRawNoCode)[i])
  dev.off()
}
# Presence of clearly problematic outliers.
# A logit(x) transformation is recommended for BER, as its value lie strictly within the (0,1) interval.
# A log(x + ε) transformation is more suitable for AWGN Power, given its unbounded positive domain.

# New meanBER_nc
logitBER_nc <- log(dataRawNoCode$meanBER_nc / (1 - dataRawNoCode$meanBER_nc))
png(filename = paste0("../../results/boxplots/box_nc/", "boxplot_logitBER_nc.png"))
boxplot(logitBER_nc, main = "logitBER_nc")
dev.off()

# New meanAWGN_POWER_nc
epsilon <- min(dataRawNoCode$meanAWGN_POWER_nc[dataRawNoCode$meanAWGN_POWER_nc>0])*0.01
logAWGN_POWER_nc <- log(dataRawNoCode$meanAWGN_POWER_nc + epsilon)
png(filename = paste0("../../results/boxplots/box_nc/", "boxplot_logAWGN_POWER_nc.png"))
boxplot(logAWGN_POWER_nc, main = "logAWGN_POWER_nc")
dev.off()

