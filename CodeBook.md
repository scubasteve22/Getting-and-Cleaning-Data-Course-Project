# Getting and Cleaning Data - CodeBook

This document contains the definitions of the tidy dataset variables:

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
