# This R environment comes with many helpful analytics packages installed
# It is defined by the kaggle/rstats Docker image: https://github.com/kaggle/docker-rstats
# For example, here's a helpful package to load

library(tidyverse) # metapackage of all tidyverse packages

# Input data files are available in the read-only "../input/" directory
# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory

list.files(path = "../input/ejk-bike-sharing-competition-team9")

# You can write up to 20GB to the current directory (/kaggle/working/) that gets preserved as output when you create a version using "Save & Run All" 
# You can also write temporary files to /kaggle/temp/, but they won't be saved outside of the current session

bike_train<-read.csv("../input/ejk-bike-sharing-competition-team9/cleaned bike sharing training for students.csv")
head(bike_train)
str(bike_train)

bike_test<-read.csv("../input/ejk-bike-sharing-competition-team9/cleaned bike sharing test for students.csv")
head(bike_test)
str(bike_test)

# 101.1301 in the competition

# Convert workingday, seasonname and weathername to factor types
bike_train$workingday <- as.factor(bike_train$workingday)
bike_test$workingday <- as.factor(bike_test$workingday)
bike_train$seasonname <- as.factor(bike_train$seasonname)
bike_train$weathername <- as.factor(bike_train$weathername)
bike_test$seasonname <- as.factor(bike_test$seasonname)
bike_test$weathername <- as.factor(bike_test$weathername)
str(bike_train)

#  NOW TRY BUILDING MODELS
bike_train$hour_group <- cut(bike_train$hour, breaks=c(-Inf, 6, 12, 18, Inf), labels=c("night", "morning", "afternoon", "evening"))
bike_test$hour_group <- cut(bike_test$hour, breaks=c(-Inf, 6, 12, 18, Inf), labels=c("night", "morning", "afternoon", "evening"))

bike_train$sin_hour <- sin(2 * pi * bike_train$hour / 24)
bike_train$cos_hour <- cos(2 * pi * bike_train$hour / 24)
bike_test$sin_hour <- sin(2 * pi * bike_test$hour / 24)
bike_test$cos_hour <- cos(2 * pi * bike_test$hour / 24)

fit <- lm(count ~ hour_group
          + daynum
          + hour
          + sin_hour
          + cos_hour
          + workingday
          + atemp
          + humidity
          + seasonname
          + weathername
          + I(hour^2)
          + I(hour^3)
          + I(hour^4)
          + log(hour + 1)
          + daynum*hour
          + daynum*atemp
          + daynum*humidity
          + daynum*seasonname
          + hour*atemp
          + hour*workingday
          + workingday*atemp
          + workingday*humidity
          + workingday*seasonname
          + atemp*humidity
          + humidity*seasonname
          + hour*atemp*humidity,
          data = bike_train)
summary(fit)

# Take a look at the model's RMSE
forecast_train_count <- predict(fit, bike_train)
RMSE_train_count<-sqrt(mean((bike_train$count-forecast_train_count)^2))
cat("RMSE for Total Demand:", RMSE_train_count, "\n")

# Ensure that there are no negative numbers
forecast_test_count <- pmax(predict(fit, newdata = bike_test), 0)  


# Note if we're predicting casual and registered separately, we'd need
# to add them together - e.g., 

# forecast_test_count <- forecast_test_casual + forecast_test_reg

# Submit the results in the right format
# First, read in the sample submission file
# Then replace the second column (the forecasts) with your forecasts
# Then save it as a .csv file
# You can then submit the result
# Here's some code to do that, assuming that your forecast is called forecast_test_count
submit <- read.csv("../input/ejk-bike-sharing-competition-team9/bike sharing sample submission.csv")
head(submit)
submit[,2]<-forecast_test_count

head(submit)

# Now save this as a .csv file and submit it
write.csv(submit, file="bike submission.csv",row.names=F)
