##Week 4 Course Project: Humans Activities and Postural Transitions Data Set

library(dplyr)

##Download and Unzip files here

# FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file()
#unzip()

##Read trained Data
x_train <- read.table("./Raw_Data/train/X_train.txt", fill = TRUE)
y_train <- read.table("./Raw_Data/train/Y_train.txt", fill = TRUE)
sub_train <- read.table("./Raw_Data/train/subject_train.txt", fill = TRUE)

##Read test Data
x_test <- read.table("./Raw_Data/test/X_test.txt", fill = TRUE)
y_test <- read.table("./Raw_Data/test/Y_test.txt", fill = TRUE)
sub_test <- read.table("./Raw_Data/test/subject_test.txt", fill = TRUE)

##Read data description and data lables
variable_names <- read.table("./Raw_Data/features.txt", fill = TRUE)
activity_labels <- read.table("./Raw_Data/activity_labels.txt", fill = TRUE)

##Merge test and train for X and Y set
x_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)
sub_total <- rbind(sub_train, sub_test)

##Naming Logically each col 
colnames(x_total) <- variable_names[,2]
colnames(y_total) <- "ActivityID" 
colnames(sub_total) <- "SubjectID"
colnames(activity_labels) <-  c("ActivityID", "Activity")

##Merge Three datasets X, Y, Sub
Merge_Data <- cbind(sub_total, y_total, x_total) ##We choose that order so in the merged dataset we see first the subject, then the activityID and then all the variables obtained

##Extract relevant measurements (mean and strDev) on Merge_Data
SelectedColumns <- grepl("*mean\\(\\)|*std\\(\\)|ActivityID|SubjectID", names(Merge_Data))

##xtract Relevant Data
Relevant_Data <- Merge_Data[,SelectedColumns]

##Replace Logic nomenclature with Literal Nomenclature
Data <- merge(Relevant_Data, activity_labels, by = "ActivityID")
Data <- select(Data, SubjectID, Activity, 3:68)

##Obtain mean through factor 1 = Subject , factor 2 = ActivityID
tidy_Data <- aggregate(.~ SubjectID + Activity, Data, mean) ##The dot mean all the dependent variables(all the var. we want mean). The other two var are independent var.
tidy_Data <- arrange(tidy_Data, SubjectID)

# Copy tidy data set to a text file for uploading into GitHub
write.table(tidy_Data, "TidyData.txt", row.names = FALSE, quote = FALSE)




