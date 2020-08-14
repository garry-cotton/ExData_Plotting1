# Import data.table package if required
if (!require(data.table))
{
    install.packages("data.table")
    library(data.table)
}

data = fread(input="household_power_consumption.txt", sep=";", header=TRUE)[Date %in% c("1/2/2007","2/2/2007")]

# Initialize par() config
if (dev.cur() != 1)
    dev.off()

png("plot1.png")
with(
    data, 
    hist(
        as.numeric(Global_active_power), 
        col="red", 
        main="Global Active Power", 
        xlab="Global Active Power (kilowatts)"))
dev.off()