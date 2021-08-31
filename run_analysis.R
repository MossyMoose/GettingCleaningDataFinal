## You should create one R script called run_analysis.R that does the following. 
## 
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each
##   measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set
##   with the average of each variable for each activity and each subject.


# Download data
fileName<-"UCI HAR Dataset.zip"
dataUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(fileName)){
   download.file(dataUrl, fileName, method="curl")
   unzip(fileName)
}
rm(fileName)
rm(dataUrl)


# Load libraries
library(dplyr)


# Read in the data
activities<-read.table(file="./UCI HAR Dataset/activity_labels.txt", col.names=c("Code","Activity"))
features<-read.table(file="./UCI HAR Dataset/features.txt", col.names=c("N","Functions"))
xTest<-read.table(file="./UCI HAR Dataset/test/X_test.txt", col.names=features$Functions)
yTest<-read.table(file="./UCI HAR Dataset/test/Y_test.txt", col.names="Code")
subjectTest<-read.table(file="./UCI HAR Dataset/test/subject_test.txt", col.names="Subject")
xTrain<-read.table(file="./UCI HAR Dataset/train/X_train.txt", col.names=features$Functions)
yTrain<-read.table(file="./UCI HAR Dataset/train/y_train.txt", col.names="Code")
subjectTrain<-read.table(file="./UCI HAR Dataset/train/subject_train.txt", col.names="Subject")


# Merge the training and the test sets to create one data set
subjectData=rbind(subjectTest, subjectTrain)  # Merge the subject data sets
xData=rbind(xTest, xTrain)                    # Merge the x data sets
yData=rbind(yTest, yTrain)                    # Merge the y data sets
mergedData=cbind(subjectData, xData, yData)   # Merge the complete data set


# Extract the measurements on the mean and standard deviation for each measurement
# Each mean and standard deviation will have -mean() and -std() in the name
selectedData<-mergedData %>% select(Subject, Code, contains("mean"), contains("std"))


# Use descriptive activity names to name the activities in the data set
# Replace code number with name
selectedData$Code<-activities[selectedData$Code, 2]


# Label the data set with descriptive variable names
# Looked at str(selectedData as I went through it to find names to clean up)
# Replace the Code column name with Activity
names(selectedData)[2]="Activity"
# Adding descriptive names based on features_info.txt:
#   The features selected for this database come from the accelerometer and
#     gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.
names(selectedData)<-gsub("Acc", "Accelerometer",names(selectedData))
names(selectedData)<-gsub("Gyro", "Gyroscope",names(selectedData))
#   These time domain signals (prefix 't' to denote time)...
names(selectedData)<-gsub("^t", "Time",names(selectedData))
#   Also get the ones that start with angle.tBody...
names(selectedData)<-gsub("tBody", "TimeBody",names(selectedData))
#   ...the magnitude of these three-dimensional signals were calculated...
names(selectedData)<-gsub("Mag", "Magnitude",names(selectedData))
#   Note the 'f' to indicate frequency domain signals...
names(selectedData)<-gsub("^f", "Frequency",names(selectedData))
#   Spell out frequency function; looks to be mixed with mean; do before mean
names(selectedData)<-gsub(".meanFreq..", "MeanFrequency",names(selectedData))
#   Spell out the mean and standard deviation functions
names(selectedData)<-gsub(".mean..", "Mean",names(selectedData))
names(selectedData)<-gsub(".std..", "STD",names(selectedData))
#   Fix capitalization
names(selectedData)<-gsub("angle", "Angle",names(selectedData))
names(selectedData)<-gsub("gravity", "Gravity",names(selectedData))


# From the data set in step 4, create a second, independent tidy data set with the
#   average of each variable for each activity and each subject.
tidyData <- selectedData %>% group_by(Subject, Activity) %>% summarize_all(list(mean))
write.table(tidyData, "TidyData.txt", row.name=FALSE)