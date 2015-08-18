## download and unzip files
if(!dir.exists("./data")){
  dir.create("./data")
}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","./data/exdata2.zip",method="curl")
unzip("data/exdata2.zip",exdir = "./data")

## read files and assign content to NEI and SCC variables
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

#data preparation
library(dplyr)
#find SCC ids where EI.Sector values in SCC starts with Fuel Comb and contains Coal
coalIds <- (SCC %>% filter(grepl("^Fuel Comb.*Coal",EI.Sector)) %>% select(SCC))[[1]]
#remove non-coal-combustion related emissions, group by year and calculate total emissions
byyear <- NEI %>% filter(SCC %in%coalIds)  %>%
  group_by(year) %>% 
  summarize(totalems=sum(Emissions))

#plot4 PNG generation
png("plot4.png", width = 600, height = 480, units = "px") 
ggplot(byyear,aes(x=factor(year), y=totalems))+ 
  geom_point() + 
  geom_smooth(method="lm", aes(group=1)) +
  labs(title=expression("Evolution of US coal combustion-related " * PM[2.5] * " emissions"), x="year", y=expression("Coal combustion-related "* PM[2.5] * " emissions (tons)"))
dev.off()
