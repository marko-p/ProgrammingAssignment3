# Initialize the return variable
# rv <- data.frame(subject=integer()
#                  , activity=integer()
#                  , measurement=character()
#                  , stringsAsFactors = FALSE)

if (!exists("raw_train")) {
    assign("raw_train", readLines("UCI HAR Dataset/train/X_train.txt"), envir = .GlobalEnv)
}
if (!exists("raw_test")) {
    assign("raw_test", readLines("UCI HAR Dataset/test/X_test.txt"), envir = .GlobalEnv)
}

# 1. Reads the data files and merges the training and the test sets to create one data set.
train_measure <- lapply(strsplit(gsub("^ *|(?<= ) | *$", "", raw_train, perl=T), " "), as.numeric)
train_measure_df <- as.data.frame(t(structure(train_measure, row.names = c(NA, -561), class = "data.frame")))
test_measure <- lapply(strsplit(gsub("^ *|(?<= ) | *$", "", raw_test, perl=T), " "), as.numeric)
test_measure_df <- as.data.frame(t(structure(test_measure, row.names = c(NA, -561), class = "data.frame")))
features <- strsplit(readLines("UCI HAR Dataset/features.txt"), split = " ")
f_labels <- unlist(features)[is.na(as.numeric(unlist(features)))]
colnames(train_measure_df) <- f_labels
colnames(test_measure_df) <- f_labels
merged_df <- rbind(train_measure_df, test_measure_df)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
mean_std_df <- merged_df[, grepl("mean", f_labels) | grepl("std", f_labels)]

# 3. Uses descriptive activity names to name the activities in the data set
train_sub <- as.data.frame(readLines("UCI HAR Dataset/train/subject_train.txt"))
colnames(train_sub) <- "subject"
train_act <- as.data.frame(readLines("UCI HAR Dataset/train/y_train.txt"))
colnames(train_act) <- "activity"
test_sub <- as.data.frame(readLines("UCI HAR Dataset/test/subject_test.txt"))
colnames(test_sub) <- "subject"
test_act <- as.data.frame(readLines("UCI HAR Dataset/test/y_test.txt"))
colnames(test_act) <- "activity"
subjects <- rbind(train_sub, test_sub)
activities <- rbind(train_act, test_act)
activity_labels <- as.data.frame(t(as.data.frame(strsplit(readLines("UCI HAR Dataset/activity_labels.txt"), split = " "))), row.names = NULL)
rownames(activity_labels) <- NULL
colnames(activity_labels) <- c("activity", "activity_label")
activities <- merge(activities, activity_labels)
descriptive <- cbind(subjects, activities, merged_df)
descriptive_mean_std_df <- cbind(subjects, activities, mean_std_df)

# 4. Appropriately labels the data set with descriptive variable names. 
# Already done

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# TODO

# Clean up
# rm(subjects)
# rm(labels)
# rm(measure)
# rm(train)
# rm(test)

