## Merges the training and the test sets to create one data set
## 'train/X_train.txt': Training set
## 'test/X_test.txt': Test set

cat("\014")  ## Deletes console text

#required libaries - NOTE - MAY NEED INSTALLED!
library(tidyr) 
library(sqldf)
library(data.table) 

setwd("~/R")

## Process Root folder:
setwd("UCI HAR Dataset")

ActivityLabels <-read.table("activity_labels.txt")
colnames(ActivityLabels)[1] <- "ActivityID"
colnames(ActivityLabels)[2] <- "ActivityName"

Features <-read.table("features.txt")
colnames(Features)[1] <- "FeatureID"
colnames(Features)[2] <- "FeatureVariable"
Features$mean = grepl("mean",Features$FeatureVariable)
Features$std = grepl("std",Features$FeatureVariable)
##Filter down to just mean and standard deviation files?
FeaturesToKeep <- sqldf("Select FeatureVariable From Features Where mean   = 1 or std = 1")
##convert from data frame to a vector:
FeaturesToKeepList <- as.character(FeaturesToKeep[[1]])

##other two files are text info (Features_info, readme) - skipped

## Process Test folder:
setwd("~/R")
setwd("UCI HAR Dataset/test")
SubjectTest <-read.table("subject_test.txt")
colnames(SubjectTest)[1] <- "SubjectID"
XTest <-read.table("X_test.txt")
colnames(XTest) = Features$FeatureVariable
XTestClean <- XTest[FeaturesToKeepList]
YTest <-read.table("y_test.txt")
colnames(YTest)[1] <- "ActivityID"
YTestWithLabel <- sqldf("select ActivityName from YTest Left Join ActivityLabels on YTest.ActivityID = ActivityLabels.ActivityID")

#Combine columns
TestCombined <- cbind(SubjectTest, YTestWithLabel, XTestClean)

##Train folder:
setwd("~/R")
setwd("UCI HAR Dataset/train")

SubjectTrain <-read.table("subject_Train.txt")
colnames(SubjectTrain)[1] <- "SubjectID"
XTrain <-read.table("X_Train.txt")
colnames(XTrain) = Features$FeatureVariable
XTrainClean <- XTrain[FeaturesToKeepList]
YTrain <-read.table("y_Train.txt")
colnames(YTrain)[1] <- "ActivityID"
YTrainWithLabel <- sqldf("select ActivityName from YTrain Left Join ActivityLabels on YTrain.ActivityID = ActivityLabels.ActivityID")

#Combine columns
TrainCombined <- cbind(SubjectTrain, YTrainWithLabel, XTrainClean)

#Combine Test and Train Data

AllCombined <- rbind(TestCombined, TrainCombined)
AllCombined <- data.table(AllCombined)

#Summarize by Subject and Activity
AllCombinedMeans <- AllCombined[, lapply(.SD, mean), by = c("SubjectID", "ActivityName")]

#Export data
setwd("~/R")
write.table(AllCombinedMeans, "AllCombinedMeans.txt", row.names=FALSE)

