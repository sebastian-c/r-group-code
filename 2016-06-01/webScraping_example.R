# R group Meeting on Webscraping
# 8/6/2016
# Michael Rahija
# 3 hour a week R Programmer
# Team G


#Outline
#1. Description
#2. Main Skills required
#3. Working example

#What is webscraping?

##Web scraping (web harvesting or web data extraction) is a computer 
##software technique of extracting information from websites (Wikipedia).

##Web scraping focuses on the transformation of unstructured data on the web, 
##typically in HTML format, into structured data that can be stored and analyzed 
##in a central local database or spreadsheet.

##Webscraping is not getting data through APIs

#Why is it useful?

##Billion Prices Project - http://www.pricestats.com/approach/overview
##ISTAT - webscraping for labor statistics
##New data sources and NSS:  http://nsdsguidelines.paris21.org/node/716
##It's so much fun.
##Private sector uses it too!

#What resources are out there?

##Varoius tools for Python which I don't know anything about
##rvest, xml, and various other R packages


# I'll be using immobiliare.it to scrape housing data in Rome by street, 
# and computing the mean per CAP as an example. 

# You need five main skills:
#1) manipulating URLs
#2) scraping data from the web using read_html()
#3) extracting information from html using html_nodes()
#4) automating the data collection through loops and functions
#5) munging the data into something useful



#As a working example, let's say we want to scrape data on the price 
#per sq meter of houses in the provincia of Rome from
#http://www.immobiliare.it/.

#First navigate to the website and see how the information is organized.

##-Get required packages
list.of.packages <- c("tidyr", "rvest")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


library(rvest) 
library(tidyr)


#this is the url containing our urls
urlcaps <- "http://www.immobiliare.it/prezzi-mq/Lazio/Roma.html"

#read the page as html into R
?read_html
htmlcaps <- read_html(urlcaps)

#use the selector gadget to figure out the css (http://selectorgadget.com/)
#ADD Selector Gadget to Browswer (http://selectorgadget.com/) 
?html_nodes
caps <- html_nodes(htmlcaps, 
                   "#heatmapTableCap a")


#use regex to get the caps by themselves
caps <- as.character(caps)

caps <- gsub(".+_","", caps) #Ask Sebastian our regex specialist if you have any ?s
caps <- gsub("-.+","", caps)

#create the URLs containing the data we want to steal
start_url <- "http://www.immobiliare.it/prezzi-mq/Lazio/CAP_"
end <- "-Roma"

urls <- paste0(start_url,caps,end)

#view out beautiful set of urls
head(urls)

#Build a loop to scrape the data

property.list <- vector(mode = "list", length = length(urls))


#only a few for demonstration
for(i in 1:10){
  
  temp <- read_html(urls[i])
  temp <- html_nodes(temp, 
                     ".colValue:nth-child(2) , #heatmapTableStreet a")
  temp <- html_text(temp)
  streets <- temp[c(TRUE,FALSE)]
  prices <- temp[c(FALSE,TRUE)]
  
  property.list[[i]] <- data.frame(streets = streets,
                                    prices = prices)
  
}


property.df <- do.call("rbind", property.list)

#view beautiful data frame with the information
head(property.df)

##--Compute average price per cap

#separate street columns
property.df <- property.df %>% 
                  separate(streets, 
                          into = c("street", "cap"), 
                          sep = ",")

head(property.df)

#clean up prices
property.df$prices <- gsub("\\.","",property.df$prices)

property.df$prices <- as.numeric(property.df$prices)

#compute mean of each cap
final.table <- property.df %>%
                  group_by(cap) %>%
                  summarize(AveragePrice = mean(prices))
                  

final.table

