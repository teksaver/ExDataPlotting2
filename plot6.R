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
#keep only Baltimore and Los Angeles motor vehicules sources
byyear <- NEI %>% filter(SCC %in% motorvecIds, fips%in%c("24510","06037"))  %>%
  #groupe by year and location code
  group_by(year,fips) %>% 
  #calculate the total of emissions for each year/fips couple
  summarize(totalems=sum(Emissions)) %>%
  #create a factor with proper labels for each location
  mutate(fips=factor(fips,c("24510","06037"),labels=c("Baltimore City","Los angeles County")))%>%
  #rename the column for proper legending
  rename(location=fips)

#plot6 PNG generation
library(ggplot2)
png("plot6.png", width = 600, height = 480, units = "px") 
ggplot(byyear,aes(x=factor(year), y=totalems, color=location, group=location)) + 
  geom_point() + 
  geom_smooth(method="lm") +
  labs(title=expression(PM[2.5] * " motor vehicules emissions evolution comparison"), x="year", y=expression("Yearly " * PM[2.5] * " motor vehicules emissions (tons)"))
dev.off()

