plot1(){
  
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

  #Make plot 1
  png(file="plot1.png",width=480,height=480)
  hist(data$Global_active_power,col="red",main="Global Active Power",xlab="Global Active Power(kilowatts)")
  dev.off()
}