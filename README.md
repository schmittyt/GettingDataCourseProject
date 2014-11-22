#Overview:#
This readme describes the input folder structure, the processing logic and output of the script “run_analysis.R”.  

##Input:##
This code assumes the following folder structure:
* {R install location}\R = Root R folder 
* {R install location}\R\UCI HAR Dataset = Data Extracted containing the Samsung data set from the link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

##Processing:##
This code loads the following files and joins them:
* subject_test.txt
* X_test.txt
* y_test.txt
* subject_train.txt
* X_train.txt
* y_train.txt
* activity_labels.txt
* features.txt

##Output:##
After loading and joining the files, the column names are populated.  The numeric variables are then reduced to only include those with either "std" or "mean" in the name.  An extract table is created in memory which averages all the numeric variables for each unique subject and activity.  Finally a tidy data set is extracted to a text file named "AllCombinedMeans.txt".
