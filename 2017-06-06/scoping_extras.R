rm(list=ls())


# 1: mixing variable and function ------------------------------------------

n <- function(x) x/2

o <- function() {
  n <- 10
  
  n(n)
}

o()

# When it is obvious that n means a function, R ignores non-function objects in the enviroment.
# So in the evaluation of the function n(), n as a variable taking the value 10 is ignored in the
# "native" enviroment and R looks for n() one level up. 


# 2: dynamic vs lexical ---------------------------------------------------

y <- 10

f <- function(x) {
  y <- 2
  
  2*y + g(x)
  
}

g <- function(x) {
  
  x + y
  
}

f(2) 

# lexical scoping, g is looked up one level at global environment
# since g is defined in glob envir


#dynamic scoping: y is looked in the envir that it was 
# called (the calling environment is the parent frame)



