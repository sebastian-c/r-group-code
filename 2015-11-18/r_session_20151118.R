# list.files()/dir() for getting all files in a directory (example: sourcing scripts for a package)
# Assumes there are many .R files at ~/../Desktop/R/

source("~/../Desktop/R/adjacent2edge.R")
ls()
source("~/../Desktop/R/checkMethodFlag.R")
source("~/../Desktop/R/checkObservationFlag.R")
ls()
files = list.files("~/../Desktop/R/", full.names = TRUE)
for(file in files){
  source(file)
}
files = dir("~/../Desktop/R/", pattern = ".R")
for(file in files){
  source(file)
}

?rbind # Put files togeteher

## Create example datasets
write.csv(cars, file = "~/../Desktop/Data/data1.csv", row.names = FALSE)
write.csv(cars, file = "~/../Desktop/Data/data2.csv", row.names = FALSE)
write.csv(cars, file = "~/../Desktop/Data/data3.csv", row.names = FALSE)
write.csv(cars, file = "~/../Desktop/Data/data4.csv", row.names = FALSE)

files = dir("~/../Desktop/Data/", pattern = ".csv", full.names = TRUE)
data = lapply(files, read.csv)
str(data)
is(data)
newData = rbind(data[[1]], data[[2]])
data = do.call("rbind", data)
str(data)


# paste0
files = dir("~/../Desktop/Data/")
paste0("~/../Desktop/Data/", files[1])
paste("~/../Desktop/Data/", files[1])
files = paste0("~/../Desktop/Data/", files)


# save

ls()
save(data, computeYield, files, file = "~/../Desktop/test.RData")
rm(list = ls())
ls()
load("~/../Desktop/test.RData")
ls()
loadedObjects = load("~/../Desktop/test.RData")
save.image(file = "~/../Desktop/test") # Saves everything
load(file = "~/../Desktop/test")




# try

# Open up a csv file with the following name before running:
name = "~/../Desktop/Data/data1"
success = FALSE
success
while(!success){
  test = write.csv(data, file=paste0(name,".csv"), row.names = FALSE)
  print("File saved!")
}


success = FALSE
while(!success){
  test = try(write.csv(data, file=paste0(name,".csv"), row.names = FALSE))
  if(is(test, "try-error")){
    readline(("File save was unsuccessful.  Please close and press enter to try again."))
  } else {
    success = TRUE
    cat("File saved successfully!\n")
  }
}



# str/head/table


str(data)
head(data)
tail(data)
head(data, 20)
table(data$speed)
table(data)
table(data$speed, data$dist)
table(data[data$speed <= 10, ]$dist)
data$roundedSpeed = floor(data$speed/5)*5
table(data$roundedSpeed)
hist(data$speed)



# basics of lists

speed = data$speed
is(speed[1])
speed = c(speed, "a")
is(speed[1])

speed = as.list(data$speed)
is(speed[[1]])
speed[[201]] = "a"
is(speed[[1]])
speed[[202]] = speed


speed = as.list(data$speed)
do.call("c", speed)
unlist(speed)
as.vector(speed)




# Sys.info() for identifying users and sharing code (or .Rprojects)

if(Sys.info() == "browningj"){
  setwd("~/../Desktop/Data/")
} else if(Sys.info() == "campbell"){
  setwd("~/Documents/Data/")
} else {
  stop("User unknown!")
}


# (Some) RStudio shortcuts
#   CTRL+ALT+B: source up to cursor
#   CTRL+1/2: switch between console and code editor
#   Up/Down: toggle history in console
#   CTRL+SHIFT+S: Source the code in the editor
#   CTRL+SHIFT+O: Source file
#   CTRL+SHIFT+C: Toggle between comments and no comments
#   CTRL+SHIFT+/: Wraps comments to keep them from getting too long
#   CTRL+P (matching brace): Jump to the matching parenthesis
#   tab: Code completion.  Press tab while typing a function name or object name