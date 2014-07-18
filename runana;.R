library(plyr)
setwd("./Getting-and-Cleaning-Data-Course-Project/")

# Set the location of the data to use
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Set the name of the zip file we wish to extract
myzip = "Dataset.zip"

# If data file has not yet been downloaded then fetch it otherwise move on
if (!file.exists(myzip)) {
  download.file(fileurl, destfile=myzip, method="curl")
  unzip(myzip)
}

# Read the data in
### Training data
features<- read.table("./UCI HAR Dataset/features.txt", header=FALSE, stringsAsFactors=FALSE)
activity_labels<- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(activity_labels) <- c("Code", "Activity")

training_set <- read.table("./UCI HAR Dataset/train/x_train.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(training_set) <- t(features[,2])

training_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, stringsAsFactors=FALSE)
training_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(training_subject) <- c("Subject")
colnames(training_labels) <- c("Code")

training_activity=merge(training_labels, activity_labels, all=TRUE)
training_data<-cbind("Data Source" = "Training", training_subject, "Activity" = training_activity$Activity, training_set)

rm(training_subject, training_set, training_activity, training_labels)

### Test data
test_set <- read.table("./UCI HAR Dataset/test/x_test.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(test_set) <- t(features[,2])

test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, stringsAsFactors=FALSE)
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(test_subject) <- c("Subject")
colnames(test_labels) <- c("Code")

test_activity=merge(test_labels, activity_labels, all=TRUE)
test_data<-cbind("Data Source" = "Test", test_subject, "Activity" = test_activity$Activity, test_set)

rm(test_subject, test_set, test_activity, test_labels)
rm(features, activity_labels)



mean(): Mean value
std(): Standard deviation

