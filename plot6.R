# Compare emissions from motor vehicle sources in Baltimore City 
# with emissions from motor vehicle sources in Los Angeles
# County, California (fips == "06037"). Which city has seen
# greater changes over time in motor vehicle emissions?

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

## Getting the SCC codes related to motor vehicle sources
## Not having detailed instructions about how to extract this info
## it seems to be a good way giving 1138 codes
MotorVehicleCodes <- SCC[regexpr("On-Road",SCC$EI.Sector) != -1, c(1)]

## Baltimore and Los Angeles
Counties <- c("24510", "06037")

## Filtering by SCC code and county code
Emission <- NEI[NEI$SCC %in% MotorVehicleCodes & NEI$fips %in% Counties, ]

## Summing up by year and county code
Emission <- aggregate(x = Emission$Emissions, by = list(Emission$year, Emission$fips), FUN = "sum")

## Labeler function for the facet_grid (convert fips values to city names)
## See: https://github.com/hadley/ggplot2/wiki/labeller
labeller_counties <- function (variable, value) {
    lapply(value, function (x) {if (x == "24510") return ("Baltimore") else return ("Los Angeles")})
}

## Plotting with faceting based county code
## Labeling with county names instead of fips
png(filename = "plot6.png", width = 960)
g <- ggplot(Emission, aes(Group.1, x))
g + geom_line() + 
    facet_grid(. ~ Group.2, labeller = labeller_counties) +
    labs(x = "year") +
    labs(y = expression(PM[2.5] * " [tons]")) +
    labs(title = "PM2.5 emissions from motor vehicle sources in Baltimore and Los Angeles between 1999 and 2008")
dev.off()
