## Libraries loading area

        library(dplyr)
        library(data.table)
        
## Set of data transfer

        X_train <- read.table("../UCI HAR Dataset/train/X_train.txt", header = FALSE)
        X_test <- read.table("../UCI HAR Dataset/test/X_test.txt", header = FALSE)
        Y_train <- read.table("../UCI HAR Dataset/train/Y_train.txt", header = FALSE)
        Y_test <- read.table("../UCI HAR Dataset/test/Y_test.txt", header = FALSE)
        Sub_train <- read.table("../UCI HAR Dataset/train/subject_train.txt", header = FALSE)
        Sub_test <- read.table("../UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## Descriptions and features

        features <- read.table("../UCI HAR Dataset/features.txt")
        activities <- read.table("../UCI HAR Dataset/activity_labels.txt")

#### Point 1 - Merge data sets

        ## Merge Test and train
        
        X.set <- rbind(X_train, X_test)
        Y.set <- rbind(Y_train, Y_test)
        S.set <- rbind(Sub_train, Sub_test)
        
        ## Name columns variables
        
        colnames(X.set) <- t(features[2])
        colnames(Y.set) <- "activity"
        colnames(S.set) <- "subject"

        ## Merge all sets in one
        
        full.data <- cbind(X.set,Y.set,S.set)


#### Point 2 - Extract mean and std measurements

        subset.data <- full.data[, grep("*std\\(\\)*|*mean\\(\\)*|activity|subject", names(full.data), ignore.case=TRUE)]
        

#### Point 3 - Name descriptive activities
        
        subset.data$activity <- as.character(subset.data$activity)

        ## Replace values by text by index
        
        for (i in 1:6){
                subset.data$activity[subset.data$activity == i] <- as.character(activities[i,2])
        }
        
#### Point 4 - Descriptive variables names
        
        names(subset.data)<-gsub("Acc", "Accelerometer", names(subset.data))
        names(subset.data)<-gsub("Gyro", "Gyroscope", names(subset.data))
        names(subset.data)<-gsub("BodyBody", "BodyToBody", names(subset.data))
        names(subset.data)<-gsub("Mag", "Magnitude", names(subset.data))
        names(subset.data)<-gsub("^t", "Time", names(subset.data))
        names(subset.data)<-gsub("^f", "Frequency", names(subset.data))
        names(subset.data)<-gsub("-mean()", "Mean", names(subset.data), ignore.case = TRUE)
        names(subset.data)<-gsub("-std()", "STD", names(subset.data), ignore.case = TRUE)
        names(subset.data)<-gsub("-freq()", "Frequency", names(subset.data), ignore.case = TRUE)

        
#### Point 5 - TidyData dataset with average
        
        subset.tidy <- aggregate(. ~subject + activity, subset.data, mean)
        write.table(subset.tidy, file = "TidyResult.txt", row.names = FALSE)

        