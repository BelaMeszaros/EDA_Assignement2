# Of the four types of sources indicated by the type (point, 
# nonpoint, onroad, nonroad) variable, which of these four 
# sources have seen decreases in emissions from 1999–2008 for 
# Baltimore City? Which have seen increases in emissions from 
# 1999–2008? Use the ggplot2 plotting system to make a plot 
# answer this question.

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

## Filtering county code
Emission <- NEI[NEI$fips == "24510", ]

## Sum up by year and pollution type
Emission <- aggregate(x = Emission$Emissions, by = list(Emission$year, Emission$type), FUN = "sum")

## Plotting with faceting based on pollution type
png(filename = "plot3.png", width = 960, height = 480)
g <- ggplot(Emission, aes(Group.1, x))
g + geom_line() + 
    facet_grid(. ~ Group.2) +
    labs(x = "year") +
    labs(y = expression(PM[2.5] * " [tons]")) +
    labs(title = "PM2.5 emissions in Baltimore between 1999 and 2008 from different sources")
dev.off()