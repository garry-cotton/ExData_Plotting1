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

colours = c("black", "red", "blue")
data = fread(input="household_power_consumption.txt", sep=";", header=TRUE)[Date %in% c("1/2/2007","2/2/2007")]
data = mutate(data, Date.Time = dmy_hms(paste(Date, Time)))
data = data[,
            c("Date.Time", 
              "Sub_metering_1", 
              "Sub_metering_2", 
              "Sub_metering_3", 
              "Global_active_power",
              "Global_reactive_power",
              "Voltage")]

# Initialize par() config
if (dev.cur() != 1)
    dev.off()

png("plot4.png")
par(mfrow=c(2,2))

# Plot 1
with(
    data,
    plot(
        Date.Time,
        as.numeric(Global_active_power),
        type="l",
        xlab="",
        ylab="Global Active Power"))

# Plot 2
with(
    data,
    plot(
        Date.Time,
        as.numeric(Voltage),
        type="l",
        xlab="datetime",
        ylab="Voltage"))

# Plot 3
suppressWarnings({data_stack = 
    mutate(
        melt(data, id.vars="Date.Time", measure.vars=2:4),
        value = as.numeric(value))})

with(data_stack,
     plot(
         Date.Time,
         value,
         type="n",
         xlab="", 
         ylab="Energy sub metering"))

for (i in 2:4)
{
    column = names(data)[i]
    colour = colours[i-1]
    measure = as.numeric(data[,get(column)])
    points(
        data$Date.Time,
        measure,
        type="l",
        col=colour)
}

legend_names = unique(as.vector(data_stack$variable))
legend("topright", legend=legend_names, col=colours, lty=1, bty="n", cex=0.8)

# Plot 4
with(
    data,
    plot(
        Date.Time,
        as.numeric(Global_reactive_power),
        type="l",
        xlab="datetime"))

dev.off()
print("plot4.png generated.")