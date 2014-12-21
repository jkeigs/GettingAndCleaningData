library(tidyr)
library(plyr); library(dplyr)
library(reshape2)
library(stringr)
# Download and unzip file -------------------------------------------------------------
#' Establish URL
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#' Create Data Directory
if(!file.exists("Data")){dir.create("Data")}

#' Create Temp file
temp <- tempfile()
#' download file
download.file(fileURL, temp, method = "curl")
#' Unzip all files in the temp zip file to the Data directory
unzip(temp, exdir = "Data")


# Import like data sets ---------------------------------------------------
#' create list of "X_" txt files
X_paths <- c("Data/UCI HAR Dataset/test/X_test.txt", "Data/UCI HAR Dataset/train/X_train.txt")
#' Import into "X_" data frame
X_Data <- ldply(X_paths, read.table, stringsAsFactors = FALSE)
#' create list of "Y_" txt files
Y_paths <- c("Data/UCI HAR Dataset/test/Y_test.txt", "Data/UCI HAR Dataset/train/Y_train.txt")
#' Import into Y_ data frame
Y_Data <- ldply(Y_paths, read.table, stringsAsFactors = FALSE)
#' create list of "subject*" txt files
subject_paths <- c("Data/UCI HAR Dataset/test/subject_test.txt", "Data/UCI HAR Dataset/train/subject_train.txt")
#' import into "subject" data frame
subject_Data <- ldply(subject_paths, read.table, stringsAsFactors = FALSE)

#' This is the lookup table for the Y_* dataset
ActivityLabels <- read.table("Data/UCI HAR Dataset/activity_labels.txt", header=FALSE)
names(ActivityLabels) <- c("ActivityNum", "ActivityName")

#' Import Feature label
#' This is the text file that contains the labels for the X_* text file
FeatureLables <- read.table("Data/UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactors = FALSE)
names(FeatureLables) <- c("ColNum", "Label")

# Combine x, y, subject with labels ------------------------------------------------------------
## Add labels to X_Data
names(X_Data) <- FeatureLables[,2]

## Add lookup values to Y_*
names(Y_Data) <- c("ActivityNum")
Y_Data <- Y_Data %>% inner_join(ActivityLabels)

## Rename subject header
names(subject_Data) <- "SubjectNum"

## Combine
All_Data <- cbind(subject_Data, Y_Data, X_Data)

## Cleanup
rm(subject_Data, Y_Data, X_Data)


# Tidy --------------------------------------------------------------------
#' Reminder, tidy = 
#' each variable forms a column
#' each observation forms a row
#' each observational unit forms a table
#' Target data set is
#' Subject, Activity, Axis, MeasurementType(Body, Gravity, ...), mean, std, mad, ...
str(All_Data)
## Start by melting (gather in tidyr)
All_Data_melt <- 
  gather(All_Data
         , MeasurementType
         , MeasurementValue
         , -c(SubjectNum, ActivityNum, ActivityName)
         )

#cleanup
#rm(All_Data)
str(All_Data_melt)
## Now split
set.seed(2)
All_Data_split <- 
  All_Data_melt %>%
  #sample_n(100000) %>%
  separate(., 
            MeasurementType
           , into = c("MeasureName", "Stat", "Axis")
           , sep = "-"
           , extra = "merge"
           )

## filter for mean and stddev
All_Data_split_small <- 
  All_Data_split %>% 
  mutate(Stat = str_replace_all(Stat, pattern = "*\\())*", "")) %>% #head(50) %>% View(., "")
  filter(Stat %in% c("mean", "std")) 
  #distinct(SubjectNum, ActivityNum, ActivityName, MeasureName, Axis)


FinalOut <-
  All_Data_split_small %>% 
  mutate(Stat = as.factor(paste("Measurement", Stat, sep="_"))
         , MeasureName = as.factor(MeasureName)) %>%
  group_by(SubjectNum, ActivityName, MeasureName, Stat) %>%
  summarize(MeasurementAvg = mean(MeasurementValue))

FinalOut <- data.frame(FinalOut)
FinalOut2 <- FinalOut %>% mutate(Stat = as.factor(Stat)) %>% spread(Stat, MeasurementAvg)

# create output
write.table(x = FinalOut2, row.names = FALSE, file = "ProjectOutput.txt")
