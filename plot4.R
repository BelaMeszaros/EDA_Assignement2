# Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999�2008?

library(tools)
library(ggplot2)
## Checking the presence of the files
if (!file.exists('summarySCC_PM25.rds')) {
    stop('Data file must be in the project folder!')
}
if (!file.exists('Source_Classification_Code.rds')) {
    stop('Code file must be in the project folder!')
}

## Checking the consistency of the files
if md5sum('summarySCC_PM25.rds') != "189a305d64f01b1126ef50baee2b9243" {
    stop('Invalid data file!')
}
if md5sum('Source_Classification_Code.rds') != "654c37a693d7cc08fe0962e4765d9d15" {
    stop('Invalid code file!')
}

## Loading data - it may take a while
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Getting the SCC codes related to coal combustion
## Not having detailed instructions about how to extract this info
## it seems to be a good way giving 99 codes
CoalCombustionCodes <- SCC[regexpr("Comb.*Coal",SCC$EI.Sector) != -1, c(1)]

## Filtering by SCC code
Emission <- NEI[NEI$SCC %in% CoalCombustionCodes, ]

## Sum up by year
Emission <- aggregate(x = Emission$Emissions, by = list(Emission$year), FUN = "sum")

## Plotting - million tons on y axis again
png(filename = "plot4.png", width = 960)
g <- ggplot(Emission, aes(Group.1, x/1000000))
g + geom_line() + 
    labs(x = "year") +
    labs(y = expression(PM[2.5] * " [million tons]")) +
    labs(title = "PM2.5 emissions from coal combustion-related sources in the U.S. between 1999 and 2008")
dev.off()
