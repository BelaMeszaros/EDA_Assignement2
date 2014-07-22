library(tools)
## Cheking the presence of the files
if (!file.exists('summarySCC_PM25.rds')) {
    stop('Data file must be in the project folder!')
}
if (!file.exists('Source_Classification_Code.rds')) {
    stop('Code file must be in the project folder!')
}

## Cheking the consistency of the files
if md5sum('summarySCC_PM25.rds') != "189a305d64f01b1126ef50baee2b9243" {
    stop('Invalid data file!')
}
if md5sum('Source_Classification_Code.rds') != "654c37a693d7cc08fe0962e4765d9d15" {
    stop('Invalid data file!')
}

## Loading data - it may take a while
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

Emission <- aggregate(x = NEI$Emissions, by = list(NEI$year), FUN = "sum")
png(filename = "plot1.png")
plot(Emission$Group.1, Emission$x/1000000, type="l", xlab = "year",
     ylab = "total PM2.5 emission [million tons]",
     main = " Total PM2.5 emissions in the U.S. between 1999 and 2008")
dev.off()