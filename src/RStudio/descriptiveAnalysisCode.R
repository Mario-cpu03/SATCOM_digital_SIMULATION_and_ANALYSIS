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
# Strong skewness on BER, THROUGHPUT, PER and AWGN Power.
# Moderate skewness on Down THERMAL Power( and Water Vapor DENSITY, most likely due to noise on values).
# Minor skewness on other parameters.

# Extremely high Kurtosis values on BER, THROUGHPUT, PER and 
# sensibly high values for AWGN Power.

# Accentuate Platikurtic distributions on every other parameter.

# Note that the emerged skewness must be reduced with appropriate transformations.
# Moreover, a boxplot graphic evaluation is necessary in order to
# check for non-good outliers, especially on Leptokurtic distributions such as:
# BER, THROUGHPUT and AWGN Power.


