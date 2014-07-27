# plot 1. Code to plot total emissions from PM2.5 in the US from 1999 to 2008
# Coursera Exploratory Data Analysis 
# Project 2, due week 3

# set working directory 
setwd("~/Documents/R/ExData2")

# load library that contains ddply
library(plyr)  

# read in data from .rds file
my_data <- readRDS("summarySCC_PM25.rds")

# set global parameter: ps = 12 smaller font for plot labels
# mar = plot margins, scipen = favor non-scientific notation

par(ps=12)   
par(mar=c(5.1,4.1,2.1,2.1))
options(scipen = 7)

# aggregate my_data: sum the Emissions and keep associated year column 
polluteSum <- ddply(my_data, "year", summarise, Emissions = sum(Emissions))


png(file = "plot1.png", height = 480, width = 480)

# Initial Plot, x = year, y = Emissions, lty = dashed line, type = line
# yaxt = suppress y unit markers
plot(polluteSum, 
     type ='l', 
     lty = 5, 
     xlab = "Year", 
     yaxt = "n",
     ylab = expression('Emissions ' ~ PM[2.5] ~ '(million tons)'),
     main = expression("Unites States " ~ PM[2.5])
     )

# label y unit markers to make it more readable, las = 2: unit labels
# perpendicular to the axis.
axis(2, 
     at = seq(4000000, 7000000, 1000000), 
     labels = seq(4,7,1), 
     las = 2
     ) 

# fancy would be to put in the linear smoothing line...
# abline(lm(Emissions ~ year, data=polluteSum), col="blue", lty=3)

dev.off()
