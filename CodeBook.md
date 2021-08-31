---
title: "Getting and Cleaning Data Final Project Code Book"
author: "MossyMoose"
date: "8/31/2021"
output: html_document
---

This code book describes the run_analysis.R script and resulting summarized tidy data set. It presents the analysis steps, variables in the environment at the conclusion of the analysis, and more information about the data set.

## Analysis Steps

The course project requires creation of an R script called run_analysis.R that does the following steps 1-5. Substeps provide more detail about the actual processes used in R.

Dependencies: `dplyr` library

Prior to beginning the analysis, the script downloads and unzips the data. See Data, below, for information about the data set. It then reads in eight files, as described in the Variables section, below.

#### 1. Merges the training and the test sets to create one data set.

i) Merge the subject identifier data sets for testing and training

`subjectData` is created by merging using `rbind()` on `subjectTest` and `subjectTrain`

ii) Merge the data associated with testing and training

`xData` is created by merging using `rbind()` on `xTest` and `xTrain`

iii) Merge the activity codes associated with testing and training

`yData` is created by merging using `rbind()` on `yTest` and `yTrain`

iv) Merge the three data sets above to create a complete data set showing subjects, data, and activities for testing and training

`mergedData` is created by merging using `cbind()` on `subjectData` `xData` and `yData`

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

i) Each measurement of mean and standard deviation is noted with -mean() and -std(). Using dplyr, the script subsets `mergedData` to include only the Subject, Code (which contains the activity type), and any fields containing "mean" or "std". The results are stored in `selectedData`.

`selectedData` is subsetted from `mergedData` using `select(Subject, Code, contains("mean"), contains("std"))`

#### 3. Uses descriptive activity names to name the activities in the data set

i) The Code variable contains the activity codes from the `activities` data.frame. First, we rename each entry to use the activity name so it is human readable.

We replace `selectedData`'s `Code` variable with `activities[selectedData$Code, 2]`

#### 4. Appropriately labels the data set with descriptive variable names. 

i) After inserting the descriptive activities information in the prior step, we rename that variable from `Code` to `Activity`

ii) We then make the other variable names more descriptive. The data set's documentation notes a number of shorthand codes for variables, including t for time, f for frequency, Acc for accelerometer, Gyro for gyroscope, and Mag for Magnitude. We replaced these using `gSub()` on the names vector, saving the results back to the names vector.

iii) We reviewed the data set's variable names several more times using `str()` to find names that could be cleaned up. The -mean() and -std() names had been replaced by .mean.. and .std.., respectively, so we renamed those to Mean and StandardDeviation using `gsub()`, along with other short phrases that appeared. Please refer to the script to see all of the renaming steps.

#### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

i) The final step was us create a smaller tidy data set that contained the average of each variable for each activity and subject. Using `dplyr`, we used `group_by` on `selectedData` to group by Subject and Activity and then used `summarize_all` to apply the `mean` function. This results in 180 observations (=30 subjects * 6 activities) of 88 variables.

ii) We save this new data set as `TidyData.txt` using `write.table()`.


## Variables
After running the script, the following variables exist in the environment, listed in the order in which they are created. Note that some temporary variables are created and then removed during the initial data download step.

#### Data present after downloading and reading in the data files:

`activities`: Contains data (activity description) from `activity_labels.txt`, with added column names (6 observations of 2 variables)

`features`: Contains data from `features.txt`, with added column names (561 observations of 2 variables)

`xTest`: Contains data from `test/X_test.txt`, with added column names from the `features` data.frame (2,947 observations of 561 variables)

`yTest`: Contains data (activity code) from `test/Y_test.txt`, with added column name (2,947 observations of 1 variable)

`subjectTest`: Contains data (subject number) from `test/subject_test.txt`, with added column name (2,947 observations of 1 variables)

`xTrain`: Contains data from `train/X_train.txt`, with added column names from the `features` data.frame (7,352 observations of 561 variables)

`yTrain`: Contains data (activity code) from `train/y_train.txt`, with added column name (7,352 observations of 1 variable)

`subjectTrain`: Contains data (subject number) from `train/subject_train.txt`, with added column name (7,352 observations of 1 variables)

#### Data present after Step 1 of the script:

`subjectData`: Row-bound merge of `subjectTest` and `subjectTrain` (10,299 observations of 1 variable)

`xData`: Row-bound merge of `xTest` and `xTrain` (10,299 observations of 561 variables)

`yData`: Row-bound merge of `yTest` and `yTrain` (10,299 observations of 1 variable)

`mergedData`: Column-bound merge of `subjectData`, `xData`, and `yData`, forming the complete data set (10,299 observations of 563 variables)

#### Data present after Step 2 of the script:

`selectedData`: A subset of `mergedData` containing "mean" and "std" calculations (10,299 observations of 88 variables)

#### Data present after Step 5 of the script:

`tidyData`: A second, tidy data set in summarized form, with descriptive names (180 observations of 88 variables)

## Data
The data set for this project is the "Human Activity Recognition Using Smartphones Data Set." As noted on the description page at the UCI Machine Learning Repository,

>"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz."

More information about the data set is available at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. The data set is available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

#### Citation for Data Set
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.
