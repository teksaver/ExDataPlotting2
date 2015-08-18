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
  group_by(year,type) %>% 
  summarize(totalems=sum(Emissions))

#plot3 PNG generation
png("plot3.png", width = 600, height = 480, units = "px") 
ggplot(byyear,aes(x=factor(year), y=totalems, color=type, group=type))+ 
  geom_point() + 
  geom_smooth(method="lm") +
  labs(title=expression("Evolution of Baltimore City" * PM[2.5] * " emissions by type"), x="year", y=expression("Total "* PM[2.5] * " emissions (tons)"))

dev.off()

