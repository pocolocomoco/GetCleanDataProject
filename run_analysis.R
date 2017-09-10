# this script works under the assumption that the 
# current working working directory is in the
# UCI HAR Dataset

###########################################
# 1 #######################################
# #########################################
# Merge training sets into 1 ##############
###########################################
trainx <-read.table("train/X_train.txt")
testx <- read.table("test/X_test.txt")
X <- rbind(trainx,testx)

trainy <- read.table("train/y_train.txt")
testy <- read.table("test/y_test.txt")
Y <- rbind(trainy,testy)

trainSubj <- read.table("train/subject_train.txt")
testSubj <- read.table("test/subject_test.txt")
SUBJ <- rbind(trainSubj,testSubj)


###########################################
# 2 #######################################
# #########################################
# Measurements for mean and std ###########
###########################################

features <- read.table("features.txt")
meanstdfeats <- grep("-(mean|std)\\(\\)", features[, 2])
X <- X[,meanstdfeats]
names(X) <- features[meanstdfeats, 2]

###########################################
# 3 #######################################
# #########################################
# Better Descriptions for activities#######
###########################################

actlables <- read.table("activity_labels.txt")
Y[,1] <- actlables[Y[,1],2]
names(Y) <- "activity"

###########################################
# 4 #######################################
# #########################################
# labels for variables ####################
###########################################

names(SUBJ) <- "subject"

###########################################
# 5 #######################################
# #########################################
# tidy set with avgs ######################
###########################################

tidy_set <- cbind(X,Y,SUBJ)

averages_data <- ddply(tidy_set, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "AVERAGES.txt", row.name=FALSE)
