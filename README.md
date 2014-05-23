# Getting and Cleaning Data - Course Project
Joshua T Casey

## Project Instructions

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## How to execute run_analysis.R

**1. Place run_analysis.R at the same location as the unzipped data**
- Same location as "activity\_labels.txt", "features.txt", etc 

**2. Use RStudio to navigate to this location and set it as the working directory**
- You can use `setwd()` or RStudio [Files -> More -> Set As Working Directory]

**3. Run the script!**
- `source("run_analysis.R")`
- It will probably help to have a clear enviroment
- run\_analysis.R will create the merged data table as variable DT and create project\_step6.csv to dump the second independent data set for step 6.

## What I did

* Read in all relevant files ([x/y]\_[train/test].csv as well as subject\_[test/train].csv)

**1. Merges the training and the test sets to create one data set.**
- The data in the test and train data sets are the same, just grouped separately for different subjects, depending on whether that subject was selected for the test group or the train group.
- To merge, I column-bound (`cbind`) the subject (\_subject.csv), activity (\_y.csv), and measurements (\_x.csv) columns, and then row-bound (`rbind`) the test and train group together

**2. Extracts only the measurements on the mean and standard deviation for each measurement.**
- I used features.csv to find out the meaning of each activity. I grepped each of these for any name that contained "std" or "mean" to extract only the mean or standard deviation meansurements.
- I then subset the activities in the combined data to extract only those columns whose activity names included "std" or "mean"

**3. Uses descriptive activity names to name the activities in the data set**
- I made activity a factor, so they are labeled "WALKING", "SITTING", etc, instead of 1...6

**4. Appropriately labels the data set with descriptive activity names.**
- I felt that the existing measurement names were appropriate, and I would have no idea how to rename them
- All I did here was to reformat the names to remove unwanted punctuation ()- and go to camelCase.

**5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.**
- This was a little tricky, but I used the aggregate function to select the mean of each measurement for all subject/activity pairs. 
- I also changed the variable names to prepend "meanOf" to indicate that the new data was a mean of some other data
