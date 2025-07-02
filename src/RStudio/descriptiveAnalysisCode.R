### Descriptive Analysis Script (coded data)

# The descriptiveAnalysisCode script is used to define
# and analyze all the variables in the Convolutional Coded training set
# using descriptive statistic methods. The final goal is to
# evaluate distributions by defyning pivotal quantities and
# sampled moments of the variables.

# A set of graphical and textual results, that can be found in the "../../results/" directory,
# will be produced, as an output of both this and the "descriptiveAnalysisNoCode.R" script,

# The following script will be useful and necessary to the correlation analysis phase.


## EXPLORATION

sDS <- capture.output(psych::describe(dataRawCode))
summaryDataSet <- c("Summary of the non-processed Convolutional Coded channel Data Set:\n",
                    sDS, "\n",
                    "Dimension: ", dim(dataRawCode))
writeLines(summaryDataSet, "../../results/CharacterizedDataSet_ConvCode.txt")
# Strong skewness observed in BER, PER, and AWGN Power.
# Moderate skewness detected in Downlink Thermal Power and Water Vapor Density,
# likely due to value noise or non-modeled sensor variability.
# Minor skewness affects the remaining parameters.

# Extremely high kurtosis values are present in BER, and PER,
# with noticeably elevated values also in AWGN Power.

# Most of the other parameters exhibit pronounced platykurtic distributions.

# Skewness should be reduced via appropriate transformations to improve modeling accuracy.
# Additionally, a boxplot-based evaluation is advised to detect and assess
# potential outliers, particularly in leptokurtic distributions such as BER, and AWGN Power.


## GRAPHIC EVALUATION

# Boxplots
for (i in 1:10) {
  png(filename = paste0("../../results/boxplots/box_cc/", "boxplot_", names(dataRawCode)[i], ".png"))
  boxplot(dataRawCode[, i], main = names(dataRawCode)[i])
  dev.off()
}
# The coded channel shows very problematic outliers, even more accentuated than in the non-coded case.
# A more reliable communication leads to extremely rare error events, which must not be ignored.
# They represent the true edge cases where the system’s performance is tested.
# A logit(x) transformation is recommended for BER, as its value lie strictly within (0,1).
# A log(x + epsilon) transformation is appropriate for AWGN power, which spans a non-limited range.

# New meanBER_cc
logitBER_cc <- log(dataRawCode$meanBER_cc / (1 - dataRawCode$meanBER_cc))
png(filename = paste0("../../results/boxplots/box_cc/", "boxplot_logitBER_cc.png"))
boxplot(logitBER_cc, main = "logitBER_cc")
dev.off()

# New meanAWGN_POWER_nc
epsilon <- min(dataRawCode$meanAWGN_POWER_cc[dataRawCode$meanAWGN_POWER_cc>0])*0.01
logAWGN_POWER_cc <- log(dataRawCode$meanAWGN_POWER_cc + epsilon)
png(filename = paste0("../../results/boxplots/box_cc/", "boxplot_logAWGN_POWER_cc.png"))
boxplot(logAWGN_POWER_cc, main = "logAWGN_POWER_cc")
dev.off()

