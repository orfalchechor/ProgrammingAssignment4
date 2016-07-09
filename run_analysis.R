library(dplyr)

# Filenames
X_test_data   <- 'test/X_test.txt'
Y_test_data   <- 'test/y_test.txt'
S_test_data   <- 'test/subject_test.txt'
X_train_data  <- 'train/X_train.txt'
Y_train_data  <- 'train/y_train.txt'
S_train_data  <- 'train/subject_train.txt'
features_data <- 'features.txt'
activity_data <- 'activity_labels.txt'

# Helper functions
cleanUpLabels <- function(df) {
   names(df) <- gsub( "[()]*", "", names(df) )
   df
}

getLabels <- function(f) {
   # Read the test labels
   labelNames <- read.table(features_data)
   
   # Pick column 2 and lowercase the names
   labelNames <- c(tolower(labelNames[,2]) )
   labelNames
}

filterColumns <- function(df) {
   # Filter out the columns we're interested in:
   # - Mean (mean)
   # - Standard Deviation (std)
   # - Activity (activity) which is the y data
   
   colFilter <- "mean\\(\\)|std\\(\\)|activity|subject"
   filteredColumns <- grep( colFilter ,names(df))
   df[filteredColumns]
}

mergeFiles <- function(measurement, subject, activity) {
   # Read the measurement data
   X_data <- read.table(measurement)
   # Read the activity data
   Y_data <- read.table(subject)
   # Read the subject data
   S_data <- read.table(activity)
   
   # Merge X_test and Y_test to X_test
   cbind( X_data, Y_data, S_data )
}

translateActivity <- function(df,ci=ncol(df)) {
   # Translate the activity column
   # 1. Read the actual labels
   A_labels <- read.table( activity_data )
   # 2. Replace the index with the label
   #    The data is expected in the last column or 
   #    whatever index the function is called with
   df[,ci] <- sapply(df[,ci], function(z) A_labels[z,2])
   df
}

# Merge the three data files to one dataframe
testData  <- mergeFiles( X_test_data, Y_test_data, S_test_data )
trainData <- mergeFiles( X_train_data, Y_train_data, S_train_data )

# Add column names to the dataset
names(testData)  <- c(getLabels(), 'activity', 'subject' )
names(trainData) <- c(getLabels(), 'activity', 'subject' )

# Apply filter to training and test set
# Do this before merging, so the merged dataset doesn't grow too large
testData_f  <- filterColumns(testData)
trainData_f <- filterColumns(trainData)

# Merge the two filtered training sets to one
mData <- rbind( testData_f, trainData_f )
# Replace index by activity description (pass the columnindex to the function)
mData <- translateActivity(mData, ncol(mData)-1)
# Make columnnames more readable
mData <- cleanUpLabels(mData)

# Group the data by activity and subject and calculate the means
# for all values in that group, excluding activity and subject
tData <- ddply( mData, c('activity', 'subject'), 
       function(z) colMeans(z[,-c(ncol(z)-1,ncol(z))]) )

# Write the output
write.table(tData, "tData.txt", row.names = FALSE )
