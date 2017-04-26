rm(list=ls())

library('dplyr')
library('nycflights13')


# 1 common verbs --------------------------------------------------------

# filter,  arrange, mutate, transmute, select, group_by, summarize

#flights2 <- flights[,c("year","month","day","carrier")]

# A. filter

  # dplyr
  filter.d <- filter(flights, carrier %in% c("UA","AA","HA"), month %in% c(11,12,1), day >= 1 & day <= 15)

  # base R
  filter.b <- flights[flights$carrier %in% c("UA","AA","HA") &
                       flights$month %in% c(11,12,1) &
                        flights$day >= 1 & flights$day <= 15,]

# between() ~ shortcut for x >= left & x <= right 
# slice() ~ return rows by 

# B. arrange (sort)

  # dplyr
  arrange.d <- arrange(flights, month, day, desc(dep_time))

  # base R
  arrange.b <- flights[order(flights$month, flights$day, -flights$dep_time),]
  

# C. mutate
# adds new variables, keeping all old ones

  # dplyr 
  mutate.d <- mutate(flights, 
                   total_delay = arr_delay + dep_delay,
                   newvar = total_delay +1, # new variable
                   weight_total_delay = 0.3*arr_delay + 0.7*dep_delay,   # using newly created variable
                   mph = distance / air_time * 60                          # distance in miles, airtime in minutes
                   ) 

  # base R
  mutate.b <- flights
  mutate.b$gain <- flights$arr_delay - flights$dep_delay
  mutate.b$gain_weighted <- 0.3*flights$arr_delay - 0.7*flights$dep_delay
  mutate.b$mpg <- flights$distance / flights$air_time * 60


# D. transmute
# adds new variable, discarding all old ones

  # dplyr
  trans.d <- transmute(flights, 
                   total_delay = arr_delay + dep_delay,
                   mph = distance / air_time * 60 ) # distance in miles, airtime in minutes
  # base R
  trans.b <- as.data.frame(
    cbind(flights$arr_delay + flights$dep_delay, flights$distance / flights$air_time * 60)
    )

  
# E. select
# take desired columns
  
  # dplyr
  sel.d <- select(flights, carrier, dep_delay, arr_delay, origin)
  
  sel.d <- select(flights, -carrier, -dep_delay, -arr_delay, -origin)
  
  # base R
  sel.b <- flights[,c("carrier", "dep_delay", "arr_delay", "origin")]
  
  sel.b <- flights[,-(which(colnames(flights) %in% 
                               c("dep_delay", "arr_delay", "origin")))]
  

# F: group & summarize
  
  # dplyr
  by_carrier <- group_by(flights, carrier)
  grp_summary <- summarize(by_carrier, n = n(), mean = mean(arr_delay, na.rm=TRUE), sd = sd(arr_delay, na.rm=TRUE))
    
  # base R
  agg1 <- aggregate(flights["arr_delay"], by = list(carrier = flights$carrier), FUN = mean, na.rm=TRUE)
  agg2 <- aggregate(flights["arr_delay"], by = list(carrier = flights$carrier), FUN = sd, na.rm=TRUE)
  base_summary <- merge(agg1,agg2, by = "carrier", all.x = TRUE )
  
# applying many functions to many variables => summarize_each  
  
  
# 2: chain operations  ----------------------------------------------------------


# dplyr

system.time(

for ( i in 1:50 ) {
  
  delay_summary <- flights %>%
    select(1:3, carrier, arr_delay, dep_delay, distance, air_time, origin) %>%  #! mixing index and name
    filter(month %in% c(11,12,1,2), dep_delay > 1, !is.na(arr_delay), !is.na(dep_delay)) %>%
    mutate( total_delay = arr_delay + dep_delay ) %>%
    
    group_by(carrier) %>% 
    summarize( n = n(), mean = mean(total_delay), sd = sd(total_delay)) %>%
    arrange(desc(mean)) 

}

)

# base
  
system.time(
  
for (i in 1:50) {  
  
  fsub <- flights[,c("year","month","day","carrier", "arr_delay", "dep_delay", "distance", "air_time", "origin")]
  fsub <- fsub[fsub$month %in% c(11,12,1,2) & fsub$dep_delay > 1 & !is.na(fsub$arr_delay) & !is.na(fsub$dep_delay),]
  fsub$total_delay <-  fsub$arr_delay + fsub$dep_delay
  
  fsum1 <- aggregate(fsub["total_delay"], by = list(carrier = fsub$carrier), FUN = function(x) {mean(x, na.rm=TRUE)})
  fsum2 <- aggregate(fsub["total_delay"], by = list(carrier = fsub$carrier), FUN = function(x) {sd(x, na.rm=TRUE)})
  
  fsum0 <- merge(fsum1,fsum2, by = "carrier" , all.x = TRUE)
  
  fsum0 <- fsum0[order(-fsum0[,2]),]

}

)

  

# section 3: 2 table verbs ------------------------------------------------


# A. mutating joins
# integrate 2 data frames into 1 by adding new columns

(df1 <- data_frame(name = c("Lucie","Sydney"), info.a = 2:1, info.a1 = c("c","a")))
(df2 <- data_frame(name = c("Lucie","Charles"), info.a = 10, info.a1 = c("a","b")))


inner_join(df1, df2) # merge(df1,df2, by = "name")

df1 %>% left_join(df2) # merge(df1,df2, all.x = TRUE)

df1 %>% right_join(df2) # merge(df1, df2, all.y = TRUE)

df1 %>% full_join(df2, by = "name") # merge(df1,df2, all = TRUE)

# ! adds rows when there is no unique identification


# B. filtering joins
# removes rows of a data frame by another data frame

# semi_join: keeps all observations in x that have a match in y
df1 %>% semi_join(df2) 

# anti_join: drops all observations in x that have a match in y
df1 %>% anti_join(df2) 


# C. set operations

intersect(x,y)
setdiff(x,y)
union(x,y)


# ! coercion rules: columns must be of same factor level (numerics/integers are fine)

# 2+ dataframes, use Reduce()