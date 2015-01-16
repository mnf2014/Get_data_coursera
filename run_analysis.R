#getdata_coursera_project1
#reading data
Dtrain<-read.table("train/X_train.txt",header=FALSE)
Dtest<-read.table("test/X_test.txt",header=FALSE)
Ytrain<-read.table("train/y_train.txt",header=FALSE)
Ytest<-read.table("test/y_test.txt",header=FALSE)
var<-read.table("features.txt",header=FALSE,stringsAsFactors=FALSE)
s_train<-read.table("train/subject_train.txt",header=FALSE)
s_test<-read.table("test/subject_test.txt",header=FALSE)

#1_Merge data
datafull<-rbind(Dtrain,Dtest)
colnames(datafull)<-c(var[1:561,2])

#2_Select data corresponding to columns named "mean" and "std"
data_ms<-subset(datafull[,c(colnames(datafull)[grep("mean",colnames(datafull))],colnames(datafull)[grep("std",colnames(datafull))])])

#3_Naming the activities in the previous data set 
activities<-rbind(Ytrain,Ytest)
colnames(activities)<-c("Activity")
nameact<-c("walking","walking_up","walking_dn","sitting","standing","laying")
activities$Activity[activities$Activity==1]<-nameact[1]
activities$Activity[activities$Activity==2]<-nameact[2]
activities$Activity[activities$Activity==3]<-nameact[3]
activities$Activity[activities$Activity==4]<-nameact[4]
activities$Activity[activities$Activity==5]<-nameact[5]
activities$Activity[activities$Activity==6]<-nameact[6]

dataACT<-cbind(activities,data_ms)

#4_Appropriately labels the data set with descriptive variable names.
#The idea is to change upper case to lower case,to remove the first dash symbol and both parentheses.
colnames(dataACT)<-tolower(names(dataACT))
colnames(dataACT)<-sub("-","",names(dataACT))
colnames(dataACT)<-sub("\\()","",names(dataACT))

#5_Data set with the average of each variable for each activity and each subject.
subject<-rbind(s_train,s_test)
colnames(subject)<-c("subject")
data_OK<-cbind(subject,dataACT)
library(plyr)
final_file<-ddply(data_OK, .(subject,activity), numcolwise(mean,na.rm=TRUE))
write.table(final_file,file="final_file.txt",row.names=FALSE,sep=",")
