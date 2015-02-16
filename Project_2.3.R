library(ggplot2)
## get url and download the datafile from the web-site
url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, destfile = "./Dataset.zip")

## unzip data to current path. see files in the unpacked folder.
unzip("./Dataset.zip")
print(list.files(recursive = TRUE))

## read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## subset only data for Baltimore
subset_baltimore <- subset(NEI, fips == "24510")

## calculate total emissions for each year
total_emissions <- with(subset_baltimore, tapply(Emissions, list(type, year), sum, na.rm = T))

# transpose matrix and convert it to data.frame
trans <-t(total_emissions)
df <- data.frame(trans)

## add to the data.frame a column with years as factors
df <- mutate(df, Year = as.factor(dimnames(trans)[[1]]) )

## gather the data.frame by all types of sources
df_gathered <- gather(df, key, value, -Year)

## creare plots
png(file = "plot3.png")
g <- ggplot(df_gathered, aes(Year, value))
print(g+geom_line(aes(group=key, col=key)) +geom_point(aes(col=key)) +facet_grid(.~key)+
          labs(title = "Total emmisions in the Baltimore City, Maryland by types of sources") +
          labs(y = "Emissions in the Baltimore City, Maryland (tons)")+theme(axis.text.x = element_text(angle = 90, hjust = 1)))
dev.off()