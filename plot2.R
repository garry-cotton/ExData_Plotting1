# Import data.table package if required
if (!require(data.table))
{
    install.packages("data.table")
    library(data.table)
}

if (!require(dplyr))
{
    install.packages("dplyr")
    library(dplyr)
}

if (!require(lubridate))
{
    install.packages("lubridate")
    library(lubridate)
}

data = fread(input="household_power_consumption.txt", sep=";", header=TRUE)[Date %in% c("1/2/2007","2/2/2007")]
data = mutate(data, Date.Time = dmy_hms(paste(Date, Time)))

# Initialize par() config
if (dev.cur() != 1)
    dev.off()

png("plot2.png")
with(
    data,
    plot(
        Date.Time,
        as.numeric(Global_active_power),
        type="l",
        xlab="",
        ylab="Global Active Power (kilowatts)"))
dev.off()