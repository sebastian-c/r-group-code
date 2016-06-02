## ------------------------------------------------------------------------
str(chickwts)
summary(chickwts)

## ------------------------------------------------------------------------
head(chickwts, 30)

## ------------------------------------------------------------------------
chickwts[chickwts$feed == "horsebean",]

## ------------------------------------------------------------------------
chickwts[chickwts$feed %in% c("horsebean", "soybean"),]

## ------------------------------------------------------------------------
beans <- c("soybean", "castor bean", "lentil", "wheat", "beanie baby", "horsebean", "pinto bean", "potato")
grep("bean", beans)
grep("bean", beans, value=TRUE)

## ------------------------------------------------------------------------
grep("bean$", beans, value=TRUE)

## ------------------------------------------------------------------------
grepl("bean$", beans)
chickwts[grepl("bean$", chickwts$feed),]

## ---- echo=FALSE---------------------------------------------------------
sws <- structure(list(geographicAreaM49 = c("230", "230", "230", "230", 
"230", "230"), timePointYears = c("2013", "2013", "2013", "2013", 
"2013", "2014"), measuredElement = c("5320", "53200", "53201", 
"5510", "55100", "5320"), Value_measuredItemCPC_02111 = c(NA_real_, 
NA_real_, NA_real_, NA_real_, NA_real_, NA_real_), flagObservationStatus_measuredItemCPC_02111 = c(NA_character_, 
NA_character_, NA_character_, NA_character_, NA_character_, NA_character_
), flagMethod_measuredItemCPC_02111 = c(NA_character_, NA_character_, 
NA_character_, NA_character_, NA_character_, NA_character_), 
    Value_measuredItemCPC_21111.01 = c(0, 0, 0, 0, 0, 0), flagObservationStatus_measuredItemCPC_21111.01 = c("M", 
    "M", "M", "M", "M", "M"), flagMethod_measuredItemCPC_21111.01 = c("u", 
    "u", "u", "u", "u", "u")), .Names = c("geographicAreaM49", 
"timePointYears", "measuredElement", "Value_measuredItemCPC_02111", 
"flagObservationStatus_measuredItemCPC_02111", "flagMethod_measuredItemCPC_02111", 
"Value_measuredItemCPC_21111.01", "flagObservationStatus_measuredItemCPC_21111.01", 
"flagMethod_measuredItemCPC_21111.01"), class = "data.frame", row.names = c(NA, 
-6L))

## ------------------------------------------------------------------------
names(sws)

## ------------------------------------------------------------------------
grep("^Value_", names(sws), value=TRUE)

## ---- echo=FALSE---------------------------------------------------------
makenoise <- function(n, selection = letters, length = 5){
  apply(replicate(n, sample(c(selection, ""), length, replace=TRUE, prob=c(rep(0.7/length(selection), length(selection)), .3))), 2, paste0, collapse="")
}
n <- 10
noisystring <- paste0(makenoise(n), sample(1990:2015, n, rep=T), makenoise(n))

## ------------------------------------------------------------------------
noisystring

## ------------------------------------------------------------------------
gsub("[a-zA-Z]", "", noisystring)

## ---- echo=FALSE---------------------------------------------------------
n <- 10
selection <- c(letters, "&", "_")
noisystring2 <- paste0(makenoise(n, selection), sample(1990:2015, n, rep=T), makenoise(n, selection))

## ------------------------------------------------------------------------
noisystring2

## ------------------------------------------------------------------------
gsub("[^0-9]", "", noisystring2)

