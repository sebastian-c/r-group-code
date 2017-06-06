############################### Ways to learn R ###############################
## ? and ??
?matrix # documentation for function named 'matrix'
??data # All documentation files related to 'data'
help.search("Generalized linear models") ## equivalent to ??, but handles strings

## The swirl package
install.packages("swirl")
library(swirl)
swirl()

## http://cran.r-project.org/doc/manuals/r-release/R-intro.html

## Google

## Your fellow coworkers
    
################################## Data Types #################################
## base types: numeric, character, logical, factor, time
x = 1
x
x = c(1, 2, 3, 4, 5)
x
x = 1:5
x
x = rep(1, 5)
x
x = c(rep(1, 5), rep(2, 5), rep(3, 5))
x
x = rep(1:5, each = 3)
x

charVec = "a"
charVec
charVec = c("a", "b", "c")
charVec
charVec = c("a", "b", 1)
charVec # Mixing types: forces all to characters

charVec = c("a", "b", "c")
factorVec = factor(charVec)
charVec
factorVec # Note the "Levels" bit printed at the bottom

## The "logical" data type

logicalVec = TRUE
logicalVec
logicalVec = T
logicalVec
logicalVec = c(T, F, T, 3)
logicalVec
is(logicalVec)
logicalVec = c(T, F, T, "a")
logicalVec
is(logicalVec)
logicalVec = c(T, F, T, NA) # NA is special: not applicable/missing value
logicalVec
is(logicalVec)

x
x[1:5]
x[c(1,3,5)]
indexVec = 1:5
indexVec
x[indexVec]
logicalVec = (x > 2)
logicalVec
x[logicalVec]
x[x > 2]

## Dates and times

timeValue = Sys.time()
timeValue
is(timeValue)
dateValue = as.Date(timeValue)
dateValue
is(dateValue)
dateValue + 1 # Adds a day
timeValue + 1 # Adds a second
dateValue > timeValue
dateValue2 = as.Date("2015-01-01")
dateValue2 < dateValue

## Coercion: converting one data.type to another

## numeric and character
x
as.character(x)
charVec = c("1", "2", "3", "a", " 1", ",2")
as.numeric(charVec)

## numeric and factor
x
as.factor(x)
y = x + rnorm(15)
fit = glm(y ~ x)
plot(x, y, pch = 16)
lines(x, predict(fit), col = 2)
xFactor = as.factor(x)
xFactor
fitFactor = glm(y ~ xFactor)
plot(x, y, pch = 16)
lines(x, predict(fitFactor), col = 2)

factorVec = factor(c(1,4,9))
factorVec
as.numeric(factorVec) # WRONG!  Gives you group #, not actual number
as.numeric(as.character(factorVec))

## numeric and logical
logicalVec = x > 2
logicalVec
as.numeric(logicalVec)
sum(as.numeric(logicalVec))
sum(logicalVec)

## Time
characterVec = c("2014-01-01", "2015-03-03", "2019-12-30")
dateVec = as.Date(characterVec)
dateVec
is(dateVec)
characterVec = c("20140101", "20150303", "20191230")
dateVec = as.Date(characterVec)
dateVec = as.Date(characterVec, format = "%Y%m%d")
dateVec
characterVec = c("Gen 01 2014", "Mar 03 2015", "Dic 30 2019")
characterVec = c("Jan 01 2014", "Mar 03 2015", "Dec 30 2019")
dateVec = as.Date(characterVec)
dateVec = as.Date(characterVec, format = "%b %d %Y")
dateVec
timeVec = as.POSIXct(characterVec, format = "%b %d %Y")
timeVec

## matrices and (mention) arrays
A = matrix(1:20, nrow = 5, ncol = 4)
A
is(A)
## Access one element
A[1, 3]
## Delete a row
A = A[-5, ]
A
## Delete a column
A = A[, -2]
A
## Add a row
A = rbind(A, c(3, 3, 3))
A
## Add a column
A = cbind(A, c(5, 5, 5, 5, 5))
A
A = cbind(A, c("a", "b", "c", "d", "e"))
A # Can only hold one data.type

## data.frames/data.tables
A = data.frame(x = 1:10, y = rep(5, 10))
A
is(A)
A[, 1] # Access column by column number
A$x # Access column by column name
A[1, ] # Access row by row number
A["1", ] # Access row by row name
A$z = 11:20
A
A$x = NULL
A
A$char = c("a", "b", "c", "d", 1:4, "g", "k")
A
is(A$y)
is(A$char)
colnames(A)
colnames(A) = c("name1", "name2", "name3")
A
rownames(A)

## lists
A = list(x = 1, y = 1:5, z = "a")
A
is(A)
A[[2]] # Access element by index number
A$y
names(A)
## Code completion in RStudio:
A$
complicatedList = list(A = A,
                       B = fit,
                       C = list(element1 = dateValue,
                                element2 = xFactor))
complicatedList
names(complicatedList)
complicatedList$
complicatedList$C$element1

## data.frames are actually lists
data = read.csv("faostat_data.csv")
is(data)
head(data)
is(data$Domain.Code)
is(data$ItemCode)
is(data$Value)
is(data) # data.frames are basically fancy lists
## sapply lets us use a function ("is", in this case) on all elements of the
## data.frame.
?sapply
sapply(data, is)
## Or, if you're more comfortable with loops, you can always use them:
for(i in 1:ncol(data))
    print(is(data[, i]))

## S4 objects
library(Matrix)
x = rbinom(10000, size = 1, p = .01)
x
A = Matrix(x) # different from matrix!
head(A)
is(A)
names(A) # So, we can't access data via A$...
slotNames(A) # It's an S4 object, so we use A@
A@i
A@x
A@Dim
A@Dimnames # I didn't set up anything here, so it's NULL
## Storing in this sparse format greatly reduces memory usage:
object.size(A) 
object.size(x)

## data.table
myData = data.frame(x = 1:1000, y = rbinom(1000, p = .5, size = 4))
myData
myData[myData$x < 200 & myData$y == 4, ]
library(data.table)
myData = data.table(myData)
## More convenient syntax than data.frame:
myData
myData[x < 200 & y == 4, ]
## Other useful ways of manipulating data:
myData[, meanX := mean(x), by = y] # Generate means within groups
myData
