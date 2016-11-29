# Getting-and-Cleaning-Data
For creating a tidy data set of wearable computing data originally from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data is downloaded from: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Files in this repo
1. README.md -- you are reading it right now
2. CodeBook.md -- codebook describing variables, the data and transformations
3. run_analysis.R -- actual R code

# Purpose of run_analysis.R 
1. Merges the training and the test sets to create one data set. 
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set 
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script assumes it has in working directory the following files and folders:
1. activity_labels.txt
2. features.txt
3. test/
4. train/
The output is created in working directory with the name of tidydata.txt

# Step in run_analysis.R 
It follows the purpose step by step.
Step 1:
  Read the entire test and train files: y_test.txt, subject_test.txt, X_test.txt, Y_train.txt, subject_train.txt, X_train.txt.
  Combine the files to a data frame in the form of subjects, activity and features.
Step 2:
  Read the features from features.txt and filter it to only leave features that are either means ("mean ()") or standard deviations   ("std()"). 
  A new data frame is then create, contains columns where measures with means, standard deviation, subject and activity
Step 3:
  Read the activity labels from activity_labels.txt and replace the numbers with the text.
Step 4:
  Replace column name with meaningful column name.
Step 5:
  Create a new data frame by finding the mean for each combination of subject and activity label. It's done by aggregate()function
Final step:
  Write the new tidy set into a text file called tidy2.txt, formatted similarly to the original files.
