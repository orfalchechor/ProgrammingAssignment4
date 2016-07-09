# run_analysis.R

## Synopsis

This document describes the run_analysis script.
The script takes as input a specific set of datafiles (see Input) and does some transformations on the data. The scripts output a tData.txt file, which contains the mean values of the mean and std values grouped subject and activity. 

## Input

The data this script operates on is download from this URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Details on the dataset can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Execution 

The script can only be run when in the directory where the zip file above is expanded.
This means that the directories 'test' and 'train' must be available and contain the correct input files. There is no error checking.

## Output

The scripts outputs a textfile tData.txt which contains the mean values for all standard deviations and mean values in the source dataset, grouped by subject and activity. The output can be read into R by using the command:

```
read.table('tData.txt', header=TRUE)
```

## Script details

### Variables

The script uses variables to specify the input files. In the rest of the script references to those variables are used, so when a filename should change, only the variable at the top of the script needs to be changed.

### Functions

The script contains several 'helper' functions, which all have a single task. 