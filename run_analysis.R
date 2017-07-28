## Set working directory

setwd("/Users/aself/Desktop/Coursera/Getting and cleaning")

## Package "Downloader" for getting and unzipping

download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./")

##Read in data to be merged

subject_train <- read.table("/Users/aself/Desktop/Coursera/Getting and cleaning/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("/Users/aself/Desktop/Coursera/Getting and cleaning/UCI HAR Dataset/train/X_train.txt")
y_train <-read.table("/Users/aself/Desktop/Coursera/Getting and cleaning/UCI HAR Dataset/train/y_train.txt")


subject_test <- read.table("/Users/aself/Desktop/Coursera/Getting and cleaning/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("/Users/aself/Desktop/Coursera/Getting and cleaning/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("/Users/aself/Desktop/Coursera/Getting and cleaning/UCI HAR Dataset/test/y_test.txt")

activity_labels <- read.table("/Users/aself/Desktop/Coursera/Getting and cleaning/UCI HAR Dataset/activity_labels.txt")

features <- read.table("/Users/aself/Desktop/Coursera/Getting and cleaning/UCI HAR Dataset/features.txt")

## Assign column names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <-c("activityId", "activityType")


## Combine test data
test_set <- cbind(subject_test, y_test, x_test)
## Combine train data
train_set <- cbind(subject_train, y_train, x_train)

## combine all data into master set
master_set <- rbind(train_set, test_set)

c_names <- colnames(master_set)

## Keep only stds and means

mean_std <- (grepl("activityId" , c_names) | 
                   grepl("subjectId" , c_names) | 
                   grepl("mean.." , c_names) | 
                   grepl("std.." , c_names) 
)

mean_std_set <- master_set[ , mean_std == TRUE]
set_with_names <- merge(mean_std_set, activity_labels,by = 'activityId',all.x=TRUE)

## Creating the second tidy data set for the 5th step

tidyset_2 <- aggregate(. ~subjectId + activityId, set_with_names,mean)
tidyset_2 <-tidyset_2 [order(tidyset_2$subjectId, tidyset_2$activityId),]
write.table(tidyset_2, "tidyset_2.txt", row.name=FALSE)
write.csv(tidyset_2, "tidyset_2.csv")

