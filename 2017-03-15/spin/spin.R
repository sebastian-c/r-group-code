#' # Turning a script into a document
#' 
#' Sometimes, you might not want to start making a document. You may want to
#' simply document a script and have a document that goes with and not have to
#' separate everything into chunks

#+ include = FALSE
1+1 # Something not displayed

#+ firstlook, echo = TRUE
head(mtcars)

#+ plot, echo = FALSE
plot(hp ~ cyl, data = mtcars)

read_chunk("child_document.R")
#+ child-chunk