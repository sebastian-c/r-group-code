#install.packages("faosws", repos = "http://hqlprsws1.hq.un.fao.org/fao-sws-cran/")
library(faosws)
library(data.table)

SetClientFiles("~/certificates/qa")
GetTestEnvironment("", # See ?GetTestEnvironment
                   "token")


d <- GetData(swsContext.datasets[[1]])
d[, Value := Value * 2]

SaveData("agriculture", "aproduction", d)
GetCodeList("agriculture", "aproduction", "geographicAreaM49")
GetDatasetConfig("Fisheries", "fisher")
GetDomainNames()
