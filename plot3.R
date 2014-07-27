# plot 3. Code to plot four types of PM25 sources (point, nonpoint, onroad, 
# nonroad) from 1999–2008 for Baltimore City.
# Coursera Exploratory Data Analysis 
# Project 2, due week 3

# set working directory 
setwd("~/Documents/R/ExData2")

# load library that contains ddply & ggplot2
library(plyr)  
library(ggplot2)
# read in data from .rds file
my_data <- readRDS("summarySCC_PM25.rds")

# set global parameter: ps = 12 smaller font for plot labels
# mar = plot margins, scipen = favor non-scientific notation

par(ps=12)   
par(mar=c(5.1,4.1,2.1,2.1))
options(scipen = 7)

# aggregate my_data: sum the Emissions and keep associated year column 
polluteBalt <- ddply(my_data[my_data$fips=="24510",], 
                     c("year","type"), 
                     summarise, 
                     Emissions = sum(Emissions))

# change polluteBalt$type to factor in preparation for comparing emissions by type
polluteBalt$type <- as.factor(polluteBalt$type)

# open graphics file 
png(file="plot3.png", width=480, height=480)

# Initial ggplot
qplot(year, Emissions, data=polluteBalt, color = type, geom="line") +
     labs(x = "Year", y = expression(PM[2.5] ~ " Emissions (tons)")) +
     labs(title = expression(PM[2.5] ~ " Emissions by Type, Baltimore")) +
     labs(colour = "Type")

# close and save graphics file.
dev.off()