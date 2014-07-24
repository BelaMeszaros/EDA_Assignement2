# Have total emissions from PM2.5 decreased in the Baltimore 
# City, Maryland (fips == "24510") from 1999 to 2008? Use the 
# base plotting system to make a plot answering this question.

library(tools)
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
Emission <- NEI[NEI$fips == "24510",]

## Sum up data by year
Emission <- aggregate(x = Emission$Emissions, by = list(Emission$year), FUN = "sum")

## Plotting - nothing special
png(filename = "plot2.png")
plot(Emission$Group.1, Emission$x, type="l", xlab = "year",
     ylab = "total PM2.5 emission [tons]",
     main = " Total PM2.5 emissions in Baltimore between 1999 and 2008")
dev.off()