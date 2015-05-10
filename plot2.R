plot2(){
  
  #If processed data file does not yet exist, download data and process
  if(!file.exists("household_poower_200702.txt")){
    #Download the data file and unzip
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile="household_power.zip")
    unzip("household_power.zip")
    
    #Write the unzipped file for reading, and open another file for writing (appending) the data only for the dates we care about
    infile<-file("household_power_consumption.txt", "r")
    outfile<-file("household_power_200702.txt", "a")
    
    #Write header info in first line to new file
    line<-readLines(infile,n=1) #read header info
    writeLines(line,outfile)    #write header info
    
    #Check for dates 01/02/2007 and 02/02/2007
    # If those dates are found, write the whole line to a new file.
    # CAUTION: this takes a LONG TIME!!
    while(length(line<-readLines(infile,n=1, warn=FALSE))){
      if(length(grep("^\"(1|2)/2/2007\";",line))>0) writeLines(line,outfile)
    }
    
    #Close new and old files when done
    close(infile)
    close(outfile)
  }
  
  #Read data into table
  data<-read.table("household_power_200702.txt", header=TRUE, sep=";", na.strings="?")
  data$Date<-as.Date(data$Date)
  data$Time<-strptime(data$Time,format="%H:%M:%S")
  
  #Make plot 2
  pts<-length(data$Global_active_power)
  par(cex=0.8)
  png(file="plot2.png",width=480,height=480)
  plot(data$Global_active_power,type="l",axes=FALSE,ylab="Global Active Power (kilowatts)", xlab="")
  axis(1, at=c(1,0.5*pts,pts), lab=c("Thu","Fri","Sat"))
  axis(2, at=seq(0,6,by=2))
  box()
  dev.off()
}