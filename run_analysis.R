library(reshape2)
#setting working Direcotry 
setwd("E:/Data Science/getCleanData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
#clear 
rm(list=ls())
#read test Data
subject_test <- read.table(file="./test/subject_test.txt")
x_test <- read.table(file="./test/X_test.txt")
y_test <- read.table(file="./test/y_test.txt")
#read train Data
subject_train <- read.table(file="./train/subject_train.txt")
x_train <- read.table(file="./train/X_train.txt")
y_train <- read.table(file="./train/y_train.txt")
#unifying the data sets
subject_all <- rbind(subject_train,subject_test)
x_all <- rbind(x_train,x_test)
y_all <- rbind(y_train,y_test)
#reading features 
features <- read.table(file="./features.txt")
#reading activities labels
activity_labels <- read.table(file="./activity_labels.txt")
#find columns for mean & standard deviation
selectedCols <- grep("-(mean|std).*",features$V2)
selectedColNames <- features[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)

x_all <- x_all[selectedCols]
allData <- cbind(subject_all, y_all, x_all)
colnames(allData) <- c("Subject", "Activity", selectedColNames)
allData$Activity <- factor(allData$Activity, levels = activity_labels[,1], labels =activity_labels[,2])
allData$Subject <- as.factor(allData$Subject)
#creating & writing tidy data set
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)
#writing data set
write.table(tidyData, "./clean-tidy-dataset.txt", row.names = FALSE, quote = FALSE,sep = ",")


