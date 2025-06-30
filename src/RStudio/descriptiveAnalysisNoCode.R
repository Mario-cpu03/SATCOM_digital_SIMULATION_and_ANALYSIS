### Descriptive Analysis Script (non-coded data)

# The descriptiveAnalysisNoCode script is used to define
# and analyze all the variables in the NoCode training set
# using descriptive statistic methods. The final goal is to
# evaluate distributions by defyning pivotal quantities and
# sampled moments of the variables.

# A set of graphical and textual results will be produced, 
# as an output of both this and the "descriptiveAnalysisCode.R" script,
# that can be found in the "../../results/" directory.

# The following script will be useful and necessary to the correlation analysis phase.

# Persistence Logic

sDS <- capture.output(summary(dataRawNoCode))
summaryDataSet <- c("Summary of the non-processed non-coded channel Data Set:\n",
                    sDS, "\n",
                    "Dimension: ", dim(dataRawNoCode))
writeLines(summaryDataSet, "../../results/CharacterizedDataSet_noCode.txt")
