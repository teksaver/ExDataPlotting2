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
#find SCC ids where EI.Sector values in SCC contains Mobile - On-Road, which suits the US definition of "motor vehicules" 
motorvecIds <- (SCC %>% filter(grepl("^Mobile - On-Road.*",EI.Sector)))[[1]]
#keep only Baltimore motor vehicules sources, group by year and calculate total emissions
byyear <- NEI %>% filter(SCC %in% motorvecIds, fips=="24510")  %>%
  group_by(year) %>% 
  summarize(totalems=sum(Emissions))

#plot5 PNG generation
library(ggplot2)
png("plot5.png", width = 600, height = 480, units = "px") 
ggplot(byyear,aes(x=factor(year), y=totalems))+ 
  geom_point() + 
  geom_smooth(method="lm", aes(group=1)) +
  labs(title=expression("Evolution of motor vehicules sources " * PM[2.5] * " emissions in Baltimore city"), x="year", y=expression("Motor Vehicules-related "* PM[2.5] * " emissions (tons)"))
dev.off()

