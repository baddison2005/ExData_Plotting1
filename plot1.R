#This script obtains the electric power consumption dataset from the course website,
#loads it into R, and produces a bar graph of Global Active Power vs Frequency.

#load necessary libraries.
library(R.utils)
library(lubridate)
library(plyr)

#Set the url of dataset from the course website.
url_dataset <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#Directory location of project and filename for dataset.
directory <- "/Users/brettaddison/Dropbox/Coursera_data_science/Exploratory_Data_Analysis/Week1/Project/"
png_name <- "plot1.png"
power_consumption_file_zip <- paste0(directory, "household_power_consumption.zip")
power_consumption_file <- paste0(directory, "household_power_consumption.txt")
png_filename <- paste0(directory, png_name)

#Download the dataset.
download.file(url_dataset, power_consumption_file_zip, method="curl")

#unzip file.
unzip(power_consumption_file_zip, overwrite=TRUE)

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

#Now make a bar graph.
#Open the png device.
png(file = png_filename)

#Plot the bar plot.
with(dataset, hist(Global_active_power, breaks=12, freq=TRUE, col="red",
                   main="Global Active Power", xlab="Global Active Power (kilowatts)",
                   ylab="Frequency"))

#Close and writeout the plot.
dev.off()