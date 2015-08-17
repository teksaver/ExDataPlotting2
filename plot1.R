## download and unzip files
if(!dir.exists("./data")){
  dir.create("./data")
}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","./data/exdata2.zip",method="curl")
unzip("data/exdata2.zip",exdir = "./data")

## read files and assign content to NEI and SCC variables
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

#calculate totals by year
library(dplyr)
byyear <- group_by(NEI,year) %>% summarize(totalems=sum(Emissions))

#plot1 PNG generation
png("plot1.png", width = 480, height = 480, units = "px") 
with(byyear,plot(year,totalems, xlab="Year",ylab=expression("Total " * PM[2.5] * " emissions (tons)")))
with(byyear,lines(year,totalems))
title(main = expression("Evolution of total " * PM[2.5] * " from 1999 to 2008"))  
dev.off()

