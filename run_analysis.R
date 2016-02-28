datadir <- "UCIDT"
testdir <- "UCIDT/test"
traindir <- "UCIDT/train"

## Read the data
xtext <- read.table(paste(testdir,"/X_test.txt", sep=""), header = FALSE)
ytext <- read.table(paste(testdir,"/y_test.txt", sep=""), header = FALSE)
stext <- read.table(paste(testdir,"/subject_test.txt", sep=""), header = FALSE)

train_xtext <- read.table(paste(traindir,"/X_train.txt", sep=""), header = FALSE)
train_ytext <- read.table(paste(traindir,"/y_train.txt", sep=""), header = FALSE)
train_stext <- read.table(paste(traindir,"/subject_train.txt", sep=""), header = FALSE)

## Combine data from test and train
xtext <- rbind(xtext,train_xtext)
ytext <- rbind(ytext,train_ytext)
stext <- rbind(stext,train_stext)

rm(train_xtext)
rm(train_stext)
rm(train_ytext)

## Read features
features <- read.table(paste(datadir,"/features.txt", sep=""), header = FALSE)

## Extract only mean and std measurements
featidx <- features[grep("-mean|std",features$V2),1]
## In this case extract columns not rows
xtext <- xtext[,featidx]


## Appropriately labels the data set with descriptive variable names.
## Take names from the features vector
colnames(xtext) <- features[grep("-mean|std",features$V2),2]

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Read activities
activ <- read.table(paste(datadir,"/activity_labels.txt", sep=""), header = FALSE)

##Take only subjects corresponding to mean and std measurements
tidydat <- xtext
colnames(stext) <- c("subject")
tidydat <- cbind(tidydat,stext)

## Add activity column to xtext
colnames(ytext) <- c("activity")
tidydat <- cbind(tidydat,ytext)

library(dplyr)

tidydata_gpby <- tidydat%>% group_by(activity, add = TRUE) %>% 
                 group_by(subject, add = TRUE)%>% summarise_each(funs(mean))

write.table(tidydata_gpby, "tidydata.csv", sep=",")
