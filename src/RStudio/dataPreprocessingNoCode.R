### Data Preprocessing Script (non-coded data)

# The dataPreprocessingNoCode script is used as a first step
# towards an exploration data analysis, aiming to check
# the dataRawNoCode data set properties.
# Dimensions, NA values, variables domain and modalities will be checked
# in order to define an omogeneous set of values that can be correctly modeled.


## PRELIMINARY CONTROLS

# First rows check
cat ("\nVerifying structural integrity of the non-coded channel data set\n")
header <- head(dataRawNoCode)
print(header)

# NA check
cat("\nControl on NA values presence\n")
if (sum(is.na(dataRawNoCode))==0){
  cat ("No NA(s) have been found\n")  
} else {
  nas <- sum(is.na(dataRawNoCode))
  print(nas); cat(" NA(s) have been found\n")
}

# Coherence check on columns names
cat("\nVariables names:\n")
namesData <- colnames(dataRawNoCode)
print(namesData)


## STRUCTURAL CONTROLS

# Dimensional check: MonteCarlo x 11
cat("\nData dimension:\n")
dimension<- dim(dataRawNoCode)
print(dimension)

# Domain check
cat("\nVariables domain:\n")
sapply(dataRawNoCode, class)

# Variability range check
for (i in 1:10){
   unique(dataRawNoCode[, i])
}
# No Binary (categorial) variables have been found 
# NOTE: meanPER_nc = {0.33, 0, 1, 0.66} so it is not a continuous distribution
