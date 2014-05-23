PrettyFeatureName <- function(str)
{
  if(is.na(str))
  {
    stop("PrettyFeatureName: arg cannot be na")
  }
  else if(!is.character(str))
  {
    stop("PrettyFeatureName requires a string")
  }
  else
  {
    str <- gsub("[()-]", "", str)
    str <- gsub("mean", "Mean", str)
    str <- gsub("std", "Std", str)
    str
  }
}

TryReadTableFile <- function(filename, ...)
{
  if(is.na(filename))
  {
    stop("TryReadTableFile: arg cannot be na")
  }
  else if(!is.character(filename))
  {
    stop("TryReadTableFile requires a string")
  }
  else if(!file.exists(filename))
  {
    stop("TryReadTableFile requires a valid filename")
  }
  else
  {
    print(paste("Reading", filename))
    result <- read.table(filename, ...)
    result
  }
}

if(!all(file.exists(
  c("features.txt",
    "./test/X_test.txt",
    "./test/y_test.txt",
    "./test/subject_test.txt",
    "./train/X_train.txt",
    "./train/y_train.txt",
    "./train/subject_train.txt"))))
{
  stop("You must be in the wrong directory!!!")
} else
{
  print("You appear to be in the right directory")
}

print("Reading in large data files, this will take a second...")
test_x <- TryReadTableFile("./test/X_test.txt")
test_y <- TryReadTableFile("./test/y_test.txt")
test_subject <- TryReadTableFile("./test/subject_test.txt")

train_x <- TryReadTableFile("./train/X_train.txt")
train_y <- TryReadTableFile("./train/y_train.txt")
train_subject <- TryReadTableFile("./train/subject_train.txt")

features <- TryReadTableFile("features.txt", stringsAsFactors=F)

activity_labels <- TryReadTableFile("activity_labels.txt")
names(activity_labels) <- c("id", "ActivityName")

print("Data files have been read in!")
names(features) <- c("id","name")

names(test_x) <- features$name
names(train_x) <- features$name

# Step 2: Extract only the data with "mean" or "std" in the activity name
# Yes, this is out of order, but works
featuresPrettyL <- grepl("mean|std", features$name)
features_pretty <- features[featuresPrettyL, "name"]

# Step 3: Use nicer names to describe the activities in the data set
features_pretty <- lapply(features_pretty, FUN=PrettyFeatureName)

test_x <- test_x[,features[featuresPrettyL, "name"]]
train_x <- train_x[,features[featuresPrettyL, "name"]]

# Step 1: Merge the two data sets
DT <- cbind(test_subject, test_y, test_x)
DT <- rbind(DT, cbind(train_subject, train_y, train_x))

# Step 4: Use descriptive activity names to label the data
names(DT) <- c("Subject", "Activity", features_pretty)

DT <- DT[order(DT$Subject, DT$Activity), ]

# Step 6: Create a second, indepedent tidy data set
meanOfMeansStd <- aggregate(DT, by=list(DT$Activity, DT$Subject), FUN=mean)
meanOfMeansStd <- meanOfMeansStd[3:length(meanOfMeansStd)]

DT$Activity <- factor(DT$Activity, labels=activity_labels$ActivityName)
meanOfMeansStd$Activity <- factor(meanOfMeansStd$Activity, labels=activity_labels$ActivityName)
names(meanOfMeansStd) <- c("Subject", "Activity", paste("meanOf", features_pretty, sep=""))

# Write that second data set to a file
print("Writing second, independent tidy data set to project_step6.txt")
write.table(meanOfMeansStd, file="project_step6.txt", sep=", ", row.names=F)
