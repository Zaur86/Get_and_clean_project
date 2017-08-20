run_analysis <- function(data = "UCI HAR Dataset") {
  
  library(dplyr)
  
  # Check the data set...
  
  if (!file.exists(data)) return(NA)
  
  # Read data sets
  
  wd <- getwd()
  
  data_path <- paste0("/",data)
  
  setwd(paste0(getwd(),data_path))
  
  activity_labels <- read.table("activity_labels.txt")
  features <- read.table("features.txt")
  
  x_train <- read.table("train/X_train.txt")
  y_train <- read.table("train/y_train.txt")
  subject_train <- read.table("train/subject_train.txt")
  
  x_test <- read.table("test/X_test.txt")
  y_test <- read.table("test/y_test.txt")
  subject_test <- read.table("test/subject_test.txt")
  
  #Merging the training and the test sets
  
  train <- mutate(x_train, activity = y_train$V1, 
                        subject_id = subject_train$V1)
  
  test <- mutate(x_test, activity = y_test$V1, 
                 subject_id = subject_test$V1)
  
  all_data <- merge(train,test,all = TRUE)
  
  
  #Extracting the measurements on the mean and 
                #standard deviation for each measurement
  
  features$V2 <- as.character(features$V2)
  
  mean_std <- grepl("[Mm]ean|[Ss]td", features$V2)
  
  main_features <- filter(features,mean_std)

  main_data <- all_data[,union_all(main_features$V1,c(562,563))]
  
  
  #Uses descriptive activity names to name the activities
  
  names(activity_labels) <- c("activity","activity_desc")
  
  main_data <- merge(main_data, activity_labels, by = "activity")
  
  main_data <- select(main_data,-activity)
  
  names(main_data)[length(main_data)] <- "activity"
  
  
  #Labeling the data set with descriptive variable names
  
  names(main_data)[1:86] <- main_features$V2
  
  
  #Creating independent tidy data set with the average of each 
                  #variable for each activity and each subject
  
  tidy_data <- arrange(main_data, subject_id)
  
  un_subjects_id <- unique(tidy_data$subject_id)
  un_activities <- unique(tidy_data$activity)
  
  tidy_col_length <- length(un_subjects_id) * length(un_activities)
  
  final_data <- tidy_data[1:tidy_col_length,]
  
  k <- 0
  
  for (i in un_subjects_id) {
    
    for (j in un_activities) {
      
      k <- k+1
      
      final_data[k,1:86] <- as.numeric(colMeans(tidy_data[tidy_data$activity==j 
                                & tidy_data$subject_id==i,1:86]))
      
      final_data[k,87] <- i
      final_data[k,88] <- j
      
    }
    
  } 
  
  setwd(wd) 
  
  list(main_data = main_data, final_data = final_data)
  
}