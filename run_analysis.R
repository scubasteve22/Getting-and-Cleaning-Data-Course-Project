## Course Project - Scuba22
# Ensure all necessary libraries are read in (some may not be needed in final cut)
library(knitr)      #For knitr
library(reshape)    #For rename

opts_chunk$set(warning = FALSE, message = FALSE, echo = TRUE, 
               fig.width = 10)

### Read in raw data
# Set the location of the data to use
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Set the name of the zip file we wish to extract
myzip = "Dataset.zip"

# If data file has not yet been downloaded then fetch it otherwise move on
if (!file.exists(myzip)) {
  download.file(fileurl, destfile=myzip, method="curl")
  unzip(myzip)
}

### Create tidy data set for training
# Read the data needed across both training and test and labels them correctly
features<- read.table("./UCI HAR Dataset/features.txt", header=FALSE, stringsAsFactors=FALSE)
activity_labels<- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(activity_labels) <- c("Code", "Activity")

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


### Create tidy data set for test
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

# Produces the knitr output required (not included in the R Markdown files)
knit("README.Rmd")   
knit("CookBook.Rmd")   
