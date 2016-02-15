#This script loads into R the electric power consumption dataset from the course website
#(it assumes you have already downloaded from running the previous script) and 
#produces a line graph of the day of the week vs Global Active Power.

#load necessary libraries.
library(R.utils)
library(lubridate)
library(plyr)

#Directory location of project and filename for dataset.
directory <- "/Users/brettaddison/Dropbox/Coursera_data_science/Exploratory_Data_Analysis/Week1/Project/"
png_name <- "plot3.png"
power_consumption_file <- paste0(directory, "household_power_consumption.txt")
png_filename <- paste0(directory, png_name)

#Now read in the dataset, but only for the dates between 2007-02-01 and 2007-02-02.
dates_column <- readTableIndex(power_consumption_file, indexColumn=1, header=TRUE, sep=";")
converted_dates_column <- as.Date(dates_column, format="%d/%m/%Y")

index <- which(converted_dates_column>=as.Date("2007-02-01", format="%Y-%m-%d")
               & converted_dates_column<=as.Date("2007-02-02", format="%Y-%m-%d"))

num_rows <- length(index)

dataset <- read.table(power_consumption_file, header=TRUE, sep=";", na.strings="?",
                      nrows=num_rows, skip = index[1]-1,
                      col.names=c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#Format the date column of this dataset.
dataset$Date <- as.Date(dataset$Date, format="%d/%m/%Y")

#Now combine the date and time column into one.
dataset$Date <- strptime(paste(dataset$Date, dataset$Time), format = "%Y-%m-%d %H:%M:%S")
dataset$Time <- NULL
names(dataset)[names(dataset)=="Date"] <- "Date_Time"

#Create a day of the week vector.
day_week <- as.factor(weekdays(dataset$Date_Time))

#Now make a line graph.
#Open the png device.
png(file = png_filename)

#Plot sub_metering_1.
with(dataset, plot(Date_Time, Sub_metering_1, type="l", ylab="Energy sub metering",
                   xlab="Day of the Week"))

#Plot sub_metering_2.
with(dataset, points(Date_Time, Sub_metering_2, type="l", col="red"))

#Plot sub_metering_3.
with(dataset, points(Date_Time, Sub_metering_3, type="l", col="blue"))

#Now add the legend.
legend("topright", lty="solid", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#Close and writeout the plot.
dev.off()