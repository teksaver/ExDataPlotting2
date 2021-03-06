## download and unzip files
if(!dir.exists("./data")){
  dir.create("./data")
}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","./data/exdata2.zip",method="curl")
unzip("data/exdata2.zip",exdir = "./data")

## read files and assign content to NEI and SCC variables
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

#filter for Baltimore data and calculate totals by year
library(dplyr)
byyear <- filter(NEI,fips=="24510")  %>%
  group_by(year) %>% 
  summarize(totalems=sum(Emissions))

#plot 2 PNG generation
png("plot2.png", width = 480, height = 480, units = "px") 
with(byyear,plot(year,totalems, xlab="Year",ylab=expression("Baltimore City " * PM[2.5] * " emissions (tons)")))
#add regression line to show trend
model <-lm(totalems ~ year, byyear)
abline(model, lwd=2)
#add title
title(main = expression("Evolution of Baltimore City" * PM[2.5] * " emissions from 1999 to 2008"))  
dev.off()

