library(data.table) # all in one and fast
# we used 1.9.8 in the tutorial

mtcars_df <- mtcars
mtcars_df$car <- rownames(mtcars)

mtcars_dt <- as.data.table(mtcars)
mtcars_dt[, car := rownames(mtcars)]
#Basic form d[i,j,by]

#subsetting

mtcars_df[mtcars_df$car == "Fiat 128",]
mtcars_dt[car == "Fiat 128",]

mtcars_dt[grepl("^Merc", car),]
mtcars_dt[car %like% "^Merc",]

# subsetting columns
## These two now give the same results as a modification was made in the
## latest version of data.table
mtcars_df[grepl("^Merc", mtcars_df$car), "wt"]
mtcars_dt[grepl("^Merc", mtcars_df$car), "wt"]

## here you can use with=FALSE or `get`

## applying functions
# help me out here: dplyr, plyr, aggregate
# get mean hp by cylinder

mtcars_dt[, mean(hp), by = cyl]


## reshaping
## data.table includes melt and dcast

dcast(mtcars_dt, sub(" .*", "", car) ~ cyl , value.var = "hp", fun.aggregate = length)

plant <- as.data.table(unstack(PlantGrowth))
melt(plant, measure.vars = c("ctrl", "trt1", "trt2"))

#speed
# big tables, easy printing
DF = data.frame(x=as.numeric(sample(x = 1e4, size = 1e7, replace = TRUE)), y = 1L, z = 1:5)
DT = as.data.table(DF)

system.time(DF[DF$x == 100L, ])
system.time(DF[DF$x == 200L, ])
system.time(DT[x == 100L,])
system.time(DT[x == 200L,]) # takes no time at all the second time

system.time(DF[DF$x %in% 500:700,])
system.time(DT[x %in% 500:700,])

DF2 <- DF
DT2 <- copy(DT)
system.time(DF$w <- cumsum(DF$x))
system.time(DT[,w := cumsum(x)])

system.time(aggregate(x ~ z, DF, function(x){sum(x)}))
system.time(DT2[, .(x = sum(x)), by = z])

#!! BONUS SECTION !!
# Changing by reference and why it can be beneficial
DF = data.frame(x=as.numeric(sample(x = 1e4, size = 1e8, replace = TRUE)), y = 1L, z = 1:5)
DT = as.data.table(DF)

system.time(DF[DF$z == 2, "z"] <- 6)
system.time(DT[z == 2, z := 6])

# This is because data.frame copies the whole object, whereas data.table changes
# it in place

## merging

full_index <- 1:5000000
ratio_in_samples <- 0.8
x <- data.table(index = sample(full_index, length(full_index)*ratio_in_samples),
                var1 = rnorm(length(full_index)*ratio_in_samples),
                key = "index")

y <- data.table(index = sample(full_index, length(full_index)*ratio_in_samples),
                var2 = rnorm(length(full_index)*ratio_in_samples),
                key = "index")

system.time(
  result <- merge(x,y, all=TRUE)
)

full_index <- 1:5000000
ratio_in_samples <- 0.8
x <- data.frame(index = sample(full_index, length(full_index)*ratio_in_samples),
                var1 = rnorm(length(full_index)*ratio_in_samples))

y <- data.frame(index = sample(full_index, length(full_index)*ratio_in_samples),
                var2 = rnorm(length(full_index)*ratio_in_samples))

system.time(
  result <- merge(x,y, all=TRUE)
)

