 ##STEP 0 - Preparation
 setwd("C:/Users/HS185031/Documents/Coursera/Getting_And_Cleaning_Data/Week4/Project")
 getwd()
 #0.1 create data folder
 if(!file.exists("./data")){dir.create("./data")}
 
 setwd("C:/Users/HS185031/Documents/Coursera/Getting_And_Cleaning_Data/Week4/Project/data")
 
 #0.2 download and unzip files
 fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 f <- file.path(getwd(), "Dataset.zip")
 download.file(fileUrl, f)
 
 #0.3 unzip and list down all the data files
  unzip("Dataset.zip")
  path_rf <- file.path("UCI HAR Dataset")
  files<-list.files(path_rf, recursive=TRUE)
  
  ##STEP 1 - Merges the training and the test sets to create one data set 
  #1.1 - Read Data files
  ActivityTest <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
  NewSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
  FeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
  
  ActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
  NewSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
  FeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
  
  # 1.2 Append the files
  dataActivity<- rbind(ActivityTrain, ActivityTest)
  dataSubject <- rbind(NewSubjectTrain, NewSubjectTest)
  dataFeatures<- rbind(FeaturesTrain, FeaturesTest)
  
  # 1.3 Define column name for Subject and Activity
  names(dataSubject)<-c("subject")
  names(dataActivity)<- c("activity")
  
  # 1.4 Define column name for Feature
  dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
  names(dataFeatures)<- dataFeaturesNames$V2
  
  # 1.5 Merge Subject, Activity and Features
  dataCombine <- cbind(dataSubject, dataActivity)
  FinaldataCombine <- cbind(dataFeatures, dataCombine)
  
  ## STEP 2 Extracts only the measurements on the mean and standard deviation for each measurement
  # 2.1 Subset dataFeaturesNames contain mean and std
  subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
  
  # 2.2 Combine Column name for measure contain mean/std with subject and Activity
  selectedCol<-c(as.character(subdataFeaturesNames), "subject", "activity" )
  FinaldataCombine <-subset(FinaldataCombine,select=selectedCol)
  
  # 2.3 Show structure if data set after subset
  str(FinaldataCombine)
  
  ##STEP 3 - Uses descriptive activity names to name the activities in the data set
  #3.1 Read activity_labels into R
  activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
  
  #3.2 Factorize variable 'Activity' in FinaldataCombine
  FinaldataCombine$activity<-factor(FinaldataCombine$activity)
  FinaldataCombine$activity<- factor(FinaldataCombine$activity,labels=as.character(activityLabels$V2))
  
  #3.3 Check result
  head(FinaldataCombine$activity,30)
  
  ##STEP 4 - Appropriately labels the data set with descriptive variable names
  # 4.1 prefix t is replaced by time
  names(FinaldataCombine)<-gsub("^t", "time", names(FinaldataCombine))
  
  # 4.2 Acc is replaced by Accelerometer
  names(FinaldataCombine)<-gsub("Acc", "Accelerometer", names(FinaldataCombine))
  
  # 4.3 Gyro is replaced by Gyroscope
  names(FinaldataCombine)<-gsub("Gyro", "Gyroscope", names(FinaldataCombine))
  
  # 4.4 prefix f is replaced by frequency
  names(FinaldataCombine)<-gsub("^f", "frequency", names(FinaldataCombine))
  
  # 4.5 Mag is replaced by Magnitude
  names(FinaldataCombine)<-gsub("Mag", "Magnitude", names(FinaldataCombine))
  
  # 4.6 BodyBody is replaced by Body
  names(FinaldataCombine)<-gsub("BodyBody", "Body", names(FinaldataCombine))
  
  # 4.7 Check
  names(FinaldataCombine)
  
  ## STEP 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  library(plyr);
  TidyData <-aggregate(. ~subject + activity, FinaldataCombine, mean)
  TidyData <-TidyData[order(TidyData$subject,TidyData$activity),]
  write.table(TidyData, file = "tidydata.txt",row.name=FALSE)
  