# A first module to use with the Statistical Working System
library(faosws)

# This returns FALSE if on the Statistical Working System
if(CheckDebug()){
  SetClientFiles("~/certificates/qa")
  GetTestEnvironment(baseUrl = "", # See ?GetTestEnvironment
                     token = "tokenhereplease")
  
  source("modules/first_module/modules/first_module/R/multiplyValue.R")
}

mult <- as.numeric(swsContext.computationParams$numberInput)

# Read in data from session key
raw_data <- GetData(swsContext.datasets[[1]])

processed_data <- raw_data[, Value := multiplyValue(Value, mult)]

# Save data back to a SWS dataset
SaveData("agriculture", "aproduction", processed_data)

"Module completed successfully"
