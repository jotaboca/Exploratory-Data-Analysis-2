# plot 2. Code to plot total emissions from PM2.5 in the US from 1999 to 2008
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
polluteBalt <- ddply(my_data[my_data$fips=="24510",], "year", summarise, Emissions = sum(Emissions))

png(file = "plot2.png", width=480, height=480)

# Initial Plot, x = year, y = Emissions, lty = dashed line, type = line
# yaxt = suppress y unit markers
plot(polluteBalt, 
     type ='l', 
     lty = 5, 
     xlab = "Year",
     yaxt = "n",
     ylab = expression('Emissions ' ~ PM[2.5] ~ '(tons)'),
     main = expression("Baltimore (24510)" ~ PM[2.5])
     )

# label y unit markers to make it more readable
axis(2, 
     at = seq(2000, 3200, 400), 
     labels = format(seq(2000, 3200, 400), big.mark = ","), 
     las = 2
     ) 

dev.off()
