# plot 5. Code to plot Baltimore vs L.A. motor vehicle emissions of 
# PM2.5 from 1999 to 2008.  
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
polluteBaltVsLA <- ddply(my_data[(my_data$fips=="24510" | my_data$fips=="06037") 
                                   & my_data$type=="ON-ROAD",],
                     c("year","type","fips"), 
                     summarise, 
                     Emissions = sum(Emissions))

# convert $type and $fips to factors for graphing purposes 
polluteBaltVsLA$type <- as.factor(polluteBaltVsLA$type)
polluteBaltVsLA$fips <- as.factor(polluteBaltVsLA$fips)

# convert 'fips' to 'City' for legend purposes 
names(polluteBaltVsLA)[names(polluteBaltVsLA) == 'fips'] <- 'City'

# convert fips codes to city names for legend purposes
levels(polluteBaltVsLA$City) <- list(
     "Baltimore" = "24510",
     "Los Angeles" = "06037"
)

# function to add commas to large numbers
commas <- function(x,...) {
     format(x, ..., scientific = FALSE, big.mark = ",")
}

# open .png device to output graph
png(file="plot6.png", width=480, height=480)

# call ggplot, with points and a line, 
graph <- ggplot(polluteBaltVsLA, aes(year, Emissions))
graph + geom_line(aes(color=City), size=2, alpha = 1/2) +
     geom_point(aes(color=City), size=3) +
     theme_bw() +
#     theme(legend.position = "bottom") +
     scale_x_continuous("Year") +
     scale_y_continuous(expression(PM[2.5] ~ " Emissions (tons)"), labels = commas) +
     ggtitle(expression(PM[2.5] ~ "Motor Vehicle Emissions, Baltimore")) +
     scale_colour_manual(values = c("goldenrod3","darkorchid2"))

# close graphic
dev.off()

