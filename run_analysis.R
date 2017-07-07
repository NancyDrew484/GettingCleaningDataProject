## Programming Assignment - Project - Getting and Cleaning Data

##
## Student:  Anne K. Geraci 
## email:  profgeraci@gmail.com
#home 
setwd("C:/Users/Anne/Documents/Google Drive/My R Code/Coursera DataScience/CleaningData/Project")
#laptop
#setwd("C:/Users/Anne/Google Drive/My R Code/Coursera DataScience/CleaningData/Project")

#work 
#setwd("C:/Users/ageraci/Documents/Google Drive/My R Code/Coursera DataScience/CleaningData/Project")
rm(list=ls())
library(data.table)

#######################################
#######################################
# Step 1.  Read the input files for the TRAIN and TEST sets to create a single dataset. 

#Read in the list of features 
inputfile = "./UCI HAR Dataset/features.txt"
df.names <- fread(inputfile, col.names=c("FeatureNum", "Feature"))

# Now let's read in the activity_labels data 
inputfile = "./UCI HAR Dataset/activity_labels.txt"
df.activityNames <- fread(inputfile, col.names=c("ActivityNum", "Activity"))

#######################################
#Read in the TRAIN data - subjects
inputfile = "./UCI HAR Dataset/train/subject_train.txt"
df1.subject <- fread(inputfile, col.names = "SubjectNum")

# Now let's read in the TRAIN data - activity numbers 
inputfile = "./UCI HAR Dataset/train/Y_train.txt"
df1.activity <- fread(inputfile, col.names="ActivityNum")


# Read in the x-value data, using the df1.names$Feature  for column names
inputfile = "./UCI HAR Dataset/train/X_train.txt"
df1.data <- fread(inputfile, header = FALSE, col.names=df.names$Feature)

#Merge the x-values data file with the data file containing the subject numbers
df1.data <- cbind(df1.subject,ActivityNum = factor(df1.activity$ActivityNum), df1.data)

#######################################
#Read in the TEST data - subjects
inputfile = "./UCI HAR Dataset/test/subject_test.txt"
df2.subject <- fread(inputfile, col.names = "SubjectNum")

# Now let's read in the TRAIN data - activity numbers 
inputfile = "./UCI HAR Dataset/test/Y_test.txt"
df2.activity <- fread(inputfile, col.names="ActivityNum")


# Read in the x-value data, using the df1.names$Feature  for column names
inputfile = "./UCI HAR Dataset/test/X_test.txt"
df2.data <- fread(inputfile, header = FALSE, col.names=df.names$Feature)

#Merge the x-values data file with the data file containing the subject numbers
df2.data <- cbind(df2.subject,ActivityNum=factor(df2.activity$ActivityNum), df2.data)

# Now we row-bind the df1 (TRAIN) and df2 (TEST) data together, creating df3
df3.data <- rbind(df1.data,df2.data)
rm(df1.data,df1.activity, df1.subject, df2.data,df2.activity,df2.subject)

#######################################
#######################################
# Step 2.  Extract only the mean and stdev values for each measurement 
# Select only the variables containing either "mean" or "std" (also keep ActivityNum and SubjectNum)
df3.data <- subset(df3.data,select=grep("ActivityNum|SubjectNum|mean|std",names(df3.data),value=TRUE))
# .... that included meanFreq - now we get rid of those columns with invert=TRUE
df3.data <- subset(df3.data,select=grep("meanFreq",names(df3.data),value=TRUE,invert=TRUE))

#######################################
#######################################
# Step 3.  Add descriptive activity names for activities
df3.data$Activity <-  factor(df3.data$ActivityNum, labels=df.activityNames$Activity)

#######################################
#######################################
# Step 4.  Appropriately labels the dataset with descriptive variable names
# No further action needed here - variables are already labeled in above steps
str(df3.data)
head(df3.data)

#######################################
#######################################
# Step 5.  CReate a second dataset with the average of each variable by activity & subject.
df4.means <- aggregate(df3.data,list(SubjectNum = df3.data$SubjectNum, ActivityNum=df3.data$ActivityNum),mean)
df4.means$Activity <- NULL
df4.means[,c(3,4)] <- NULL
str(df4.means)
