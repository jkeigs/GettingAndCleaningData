---
title: "Codebook"
output: html_document
---

The purpose of this analysis is to take the Samsung phone data and tidy it up for future analysis.  The tidying process is described in the ReadMe.md file so see there for what needed to be done and how.  This document will discuss the variables developed for the final data set.  For more background on the raw data see the readme.txt file that's included in the download.

The final output of the data contains 5 fields:

1. SubjectNum (1 - 30)
2. The activity being permormed while measurement was taking place
3. The actual measurement
4. The mean of the mean measurements
5. The mean of the standard deviation of measurments

The need for summarization is due to the fact that each subject was measured performing an activity and snapshots were taken 128 times.  This data is what is eventually summarized for this analysis.