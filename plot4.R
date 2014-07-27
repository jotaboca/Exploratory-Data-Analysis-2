# plot 4. Code to plot total emissions from PM2.5 "Across the US" from 
# 1999 to 2008. I have interpreted "across" to mean "by region."
# Coursera Exploratory Data Analysis 
# Project 2, due week 3

# set working directory 
setwd("~/Documents/R/ExData2")

# load library that contains ddply & arrange, ggplot2, excel importing, mapping functions
library(plyr)  
library(ggplot2)
library(xlsx)
library(maps)
library(mapproj)

# read in pollution data (summarySCC_PM25) and classification data (Source_
# Classification_Code) from .rds files
my_data <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset SCC to isolate codes that contain Coal in EI.Sector description
SCC.subset <- SCC[grep("Coal", SCC$EI.Sector),]

# subset my_data to isolate entries that have codes related to 
# SCC.subset$SCC Coal codes
coalSet <- my_data[my_data$SCC %in% SCC.subset$SCC,]

# add a column to coalSet to extract state FIPS code from county FIPS code
coalSet$STfips <- substr(coalSet$fips, 1, nchar(coalSet$fips)-3)

# import state geographies as defined by the US Census, 
# two digit FIPS codes correspond to first two digits of 5 digit county codes in my_data.
# download file from www.census.gov.
fileUrl <- "http://www.census.gov/popest/about/geo/state_geocodes_v2011.xls"
download.file(fileUrl, destfile = "state_geocodes_v2011.xls", method = "curl")

# read in census region data.
rowIndex <- 6:70
stateGeos <- read.xlsx("state_geocodes_v2011.xls", sheetIndex = 1, 
                       header = TRUE, rowIndex =rowIndex)

# Rename stateGeo column so it can merge/join with CoalSet
names(stateGeos)[names(stateGeos) == 'State..FIPS.'] <- 'STfips'

# join stateGeos and CoalSet so I can summarize data by region
coalSetRegion <- merge(coalSet, stateGeos)

# rename Division factors to represent region
levels(coalSetRegion$Division) <- list(
     "Region Name" = "0",
     "New England" = "1",
     "Mid-Atlantic" = "2",
     "Midwest (East)" = "3",
     "Midwest (West)" = "4",
     "South (Atlantic)" = "5",
     "South (Central)" = "6",
     "South (Western)" = "7",
     "Mountain" = "8",
     "Pacific" = "9"
)

# set global parameter: ps = 12 smaller font for plot labels
# mar = plot margins, scipen = favor non-scientific notation
par(ps=12)   
par(mar=c(5.1,4.1,2.1,2.1))
options(scipen = 7)

# aggregate data into final graphing set: sum emissions by region & year.
CoalPolluteSum <- ddply(coalSetRegion, c("Division","year"), summarise, 
     Emissions = sum(Emissions))

# open graphics file 
png(file="plot4.png", width=480, height=480)

# call plot, x = year, y = Emissions, 
qplot(year, Emissions, data=CoalPolluteSum, color = Division, geom="line") +
     labs(x = "Year", y = expression(PM[2.5] ~ " Coal Emissions (tons)")) +
     labs(title = expression(PM[2.5] ~ " Coal Emissions by US Region")) +
     labs(colour = "US Region")

dev.off()


