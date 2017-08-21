# Get_and_clean_project

# Introduction

In this project i create script, which get dirty data with results of some experiment and give us tidy data in two tables: one fo them contains all measurements (one row = one measurement) and the second – some summary (one row = averages of variables for one activity type and one subject ID).

# About script

My scrip file's name is 'run_analisys.R'. Name for calling it - 'run_analysis()'.
Script has only one argument –'data', which is a name of directory contaning our data.
By default data's name is "UCI HAR Dataset".

## 01 - Reading data

At first we check, does our directory exist in work directory. If not – function returns 'NA' value.
Our second step – to make directory with data set as work directory.
Then we read our data, creating objects.

## 02 – Merging training and test sets

At first we merge objects containing measurement variables (x_train / x_test) with objects containing measuremet 
        characteristics (y_train, subject_train / y_test, subject_test) using function 'mutate()'
Then we merge 'x_train' with 'y_train' in object 'all_data'.

## 03 – Extracting the measurements on the mean and standard deviation for each measurement

At this stage we select only theese vatiables which contain mean or standart deviation values.
To achieve this purpose we use function 'select()' and regular expressions by function 'grepl()'.

## 04 – Giving names for variables and activity values

We merge 'all_data' with 'features' to give names for variables and 
          with 'activity_labels' to convert activity values from labels to names.
          
## 05 – Creating independent tidy data set with the average for each activity and ech subject

At first we create 'tidy_data' by arranging 'all_data' by subject_id using function 'arrang()'.
We count number of values of activity and subject variables (to use this information in loop) and
        multiply them (to get number of columns for tidy we need).
We create object 'final_data' by copping 'tidy_data' with number of columns which we got by multiplying. 
By loop 'for' we give for every row of 'final_data' values:
– couple of activity and subject_iad
– values of measurements
Then we return old work directory and return to function list with two tidy data frames.
