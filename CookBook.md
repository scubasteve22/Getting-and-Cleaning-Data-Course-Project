# Getting and Cleaning Data - CookBook

This document contains the definitions of the tidy dataset variables and then the code and transformations of data:

## Definition of columns

### tidy_data.txt
+ Subject Type   - Split into "Training" or "Test" to show where the data came from i.e. whether it was training or test data
+ Subject        - The number of the Subject being tested
+ Activity       - The plain English version of the activity being performed; can be from "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING".

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

+ tBodyAcc-XYZ
+ tGravityAcc-XYZ
+ tBodyAccJerk-XYZ
+ tBodyGyro-XYZ
+ tBodyGyroJerk-XYZ
+ tBodyAccMag
+ tGravityAccMag
+ tBodyAccJerkMag
+ tBodyGyroMag
+ tBodyGyroJerkMag
+ fBodyAcc-XYZ
+ fBodyAccJerk-XYZ
+ fBodyGyro-XYZ
+ fBodyAccMag
+ fBodyAccJerkMag
+ fBodyGyroMag
+ fBodyGyroJerkMag

The set of variables that were estimated from these signals are (represented by the suffix _mean() or _std()): 

+ mean(): Mean value
+ std(): Standard deviation

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

+ gravityMean
+ tBodyAccMean
+ tBodyAccJerkMean
+ tBodyGyroMean
+ tBodyGyroJerkMean

### tidy_data_mean.txt
The is the data set built from "tidy_data.txt" that is aggregated by Activity and Subject columns and then has the mean for each column after:

+ Subject        - The number of the Subject being tested
+ Activity       - The plain English version of the activity being performed; can be from "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING".

The rest of the columns are the same definition as for "tidy_data.txt"" but are the MEAN of the column and all now have the suffix "_MEAN" to differentiate them from the earlier definitions.

## Explanation of run_analysis.R

### Set global settings

Ensuring that the correct library is loaded for knitr and setting the global chunk options:

```r
## Course Project - Scuba22

# Ensure all necessary libraries are read in (some may not be needed in final cut)
library(knitr)      #For knitr
library(reshape)    #For rename

opts_chunk$set(warning = FALSE, message = FALSE, echo = TRUE, 
               fig.width = 10)
```
Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.  `warning = FALSE` and `message = FALSE` are added to remove the uncessary warnings and messages when producing the plots.  Finally added `fig.width = 10` to make the plots wider and easier to read.

### Read in raw data

This stage reads in the .zip file and then unzips ready for use:

```r
# Set the location of the data to use
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Set the name of the zip file we wish to extract
myzip = "Dataset.zip"

# If data file has not yet been downloaded then fetch it otherwise move on
if (!file.exists(myzip)) {
  download.file(fileurl, destfile=myzip, method="curl")
  unzip(myzip)
}
```

### Create tidy data set for training

Firstly I bring in the data that will be on both test and training; namely the columns definitions (features.txt) and the activity look-up table (activity_labels.txt): 

```r
# Read the data needed across both training and test and labels them correctly
features<- read.table("./UCI HAR Dataset/features.txt", header=FALSE, stringsAsFactors=FALSE)
activity_labels<- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(activity_labels) <- c("Code", "Activity")
```

I decided to tidy up the test and training data seperately first to reduce the overall amount of data being moved around.  Firstly I clean the training data (1) by applying the correct columns headings from the features table, (2) bringing in the activity meanings from activity labels, (3) bringing all the data together and only retaining set data where we find mean() - mean value - and std() - standard deviation; I decided to use these definitions to meet the Course Project requirement as it was consistent with the definition in the original read.txt document and, finally, (4) I clear out redundant tables to make the Global Environment easier to read:

```r
# (1) Read in the txt file and apply the column names from the features table, we know they are in column 2
training_set <- read.table("./UCI HAR Dataset/train/x_train.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(training_set) <- t(features[,2])

# (2) Read in the smaller training tables, tidy up the column headings and also bring in the activity meaning
training_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, stringsAsFactors=FALSE)
training_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(training_subject) <- c("Subject")
colnames(training_labels) <- c("Code")

# The merge to bring meaning to the activity code
training_activity=merge(training_labels, activity_labels, all=TRUE)

# (3) Brings all the data together and using grep to strip out the required columns, I had added a column to flag its Training data in case relevant
training_activity=merge(training_labels, activity_labels, all=TRUE)
training_data<-cbind("Subject Type" = "Training", 
                     training_subject, 
                     "Activity" = training_activity$Activity, 
                     subset(training_set, select=(names(training_set)[grep('mean()',names(training_set), fixed=TRUE)])),
                     subset(training_set, select=(names(training_set)[grep('std()',names(training_set), fixed=TRUE)]))
)

# (4) Delete unecessary tables; we do retain the broader features and activity_labels to be used with the test data
rm(myzip, fileurl)
rm(training_subject, training_set, training_activity, training_labels)
```

The test data follows the exact same pattern as above but for test data and then all tables are removed aside from the tidy_data necessary for the output:

```r
# (1) Read in the txt file and apply the column names from the features table, we know they are in column 2
test_set <- read.table("./UCI HAR Dataset/test/x_test.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(test_set) <- t(features[,2])

# (2) Read in the smaller training tables, tidy up the column headings and also bring in the activity meaning
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, stringsAsFactors=FALSE)
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(test_subject) <- c("Subject")
colnames(test_labels) <- c("Code")

# The merge to bring meaning to the activity code
test_activity=merge(test_labels, activity_labels, all=TRUE)

# (3) Brings all the data together and using grep to strip out the required columns, I had added a column to flag its Test data in case relevant
test_data<-cbind("Subject Type" = "Test", 
                     test_subject, 
                     "Activity" = test_activity$Activity, 
                     subset(test_set, select=(names(test_set)[grep('mean()',names(test_set), fixed=TRUE)])),
                     subset(test_set, select=(names(test_set)[grep('std()',names(test_set), fixed=TRUE)]))
)

# (4) Delete unecessary tables; we do retain the test and training tidy sets
rm(test_subject, test_set, test_activity, test_labels)
rm(features, activity_labels)
```

### Create output of the first tidy dataset

To complete the first output required I bring together the data, sort the data by Subject as I feel its easier to read for this exercise, transform the factors to characters clean out the last remaining unecessary data and then output the file to a .txt file for GitHub

```r
# Merge the 2 datasets into one tidy table and sort the table to make it readable, for this table I have decided by Subject is most relevant to see what each subject undertook
tidy_data_base <- rbind(test_data, training_data)
tidy_data <- tidy_data_base[order(tidy_data_base$"Subject", tidy_data_base$"Activity"),]

# Change the factors to chars
i <- sapply(tidy_data, is.factor)
tidy_data[i] <- lapply(tidy_data[i], as.character)

# Remove all unecessary data
rm(test_data, training_data, i, tidy_data_base)

# Output the .txt file (comma delimited) - Set row.names to false to prevent exporting row numbers and confusing column names
write.table(tidy_data, file = "tidy_data.txt", sep = ",", row.names = FALSE)
```

### Create output of the second (aggregated) tidy dataset

In this section I aggregate all the numerics and take the mean by Activity and Subject.  I remove the uncessary columns from the previous exercise and then add a suffix of "_MEAN" to the columns to differentiate from the previous exercise and then change the name of the columns used for grouping.  Finally I sort the data, this time by Activity then Subject, when I reviewed the data it seemed to make more sense to see how the Subjects varied by Activity.  The last stage is to export the data to a .txt file to share in GitHub:

```r
### Create the mean data for the second independent table
agg_base<-aggregate.data.frame(tidy_data, by=list(tidy_data$Activity, tidy_data$Subject), mean)

### Remove the unwanted columns and rename the groupings

# Identify the columns to drop
drops <- c("Subject Type", "Subject", "Activity")

# Recreate the table without them (and remove the drops data)
agg_base<-agg_base[,!(names(agg_base) %in% drops)]
rm(drops)

# Rename the group columns for clarity; both by adding _MEAN and changing the groupings
colnames(agg_base) <- paste(colnames(agg_base), "MEAN", sep = "_")
agg_base<-rename(agg_base, c("Group.1_MEAN"="Activity", "Group.2_MEAN"="Subject"))

# Sort the order to make it readable (and remove the previous data) - Order this time by activity to understand impact better across subjects
tidy_data_mean <- agg_base[order(agg_base$"Activity", agg_base$"Subject"),]
rm(agg_base)

# Output the .txt file (comma delimited) - Set row.names to false to prevent exporting row numbers and confusing column names
write.table(tidy_data_mean, file = "tidy_data_mean.txt", sep = ",", row.names = FALSE)
```

### Produce the .md output

The code below is commented out as it cause the knit to fail (but wanted it here for completeness):

```r
## Produces the knitr output required (not included in the R Markdown files)
#  knit("README.Rmd")   
#  knit("CookBook.Rmd")   
```
