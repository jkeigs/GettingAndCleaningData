GettingAndCleaningData
======================
This document describes the process used to tidy the Samsung dataset.

Initial sections loads required packages, downloads and extracts the data and finally creates data frames of like data sets.  These data frames are the raw data and are titled:

- X_Data (contains data on movements from X_test.txt and X_train.txt)
- Y_Data (contains activity info which is joined directly into this data set)

Once imported, both data sets are given appropriate headers and merged into the starting data frame titled "All_Data"

The purpose of this analysis was to provide a tidy dataset containing the mean of the mean and standard deviation for each Subject and Activity.  The target format for the data set was as follows

Subject, Activity, Axis (if applicable),  easurementType, Measurement_Mean, Measurement_StdDev

To get here tidyr, dplyr, stringr were used to 

1. Melt the data (gather)
2. Split the measurment name into name, axis and type
3. Filter for only the mean and standard deviation of each measurement
4. Summarize this into the output data set (FinalOut2)