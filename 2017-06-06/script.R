# Functions, part I
# Philip Chan, ESS
# June 6th, 2017  


# 1. basic components of a function; different kinds of arguments
# 2. lexical scoping
# 3. anonymous functions




rm(list=ls())

# 1: basics ---------------------------------------------------------------


## a. function components 
# every function is broken down to 3 parts: formals (aka arguments), body, environment

# use these functions to see the formals/body/environment of any non-primitive function
#   formals(), body(), environment

# example: 
my_func <- function(x,y) {  # function declaration with its formals x and y
  
  2*x - 6*y + 1             # the body
  2*x 
}                           # the brackets enclose this as the 'private space' of my_func


# An exception:
# Primitive functions ( such as `-`, sum(), sqrt() ) are written in C or fortran, so they have no R code. Applying body()/formals()/environment()
# on them will not return anything meaningful. Try: body(sum).


## b. default and optional argument

# In the below function, b and t hold default values that will remain as is unless explicity modified. An optional
# argument is present called adjustment; it is not activated unless explicity done so by inserting a value.

eff_func <- function(L, b = 0.5, t = 0:20, adjustment = NULL) {

  ifelse (is.null(adjustment) == TRUE, adjustment <- 0, adjustment <- adjustment) 

  output <- L - b * t^2 + adjustment
  
  output #! necessary for it to appear when called


}
# optional argument: In general, creating functions where every optional argument
# has a default value of NULL is the recommended practice.


## c. argument matching 
  #  order of operations: 
  #   1. exact match for a named argument
  #   2. partial match
  #   3. positional match

eff_func(adjustment = 2, L = 20,  t = 0:5, b = 0.5) # exact match for named argument

eff_func(L = 20, adj = 2, b = 0.5, t = 0:5 )        # partial matching

eff_func(20, 0.5, 0:5, 2)                           # positional matching
  
  
## d. the "..." argument

  # case 1: unspecified number of argument of the same type
  
  paste("These are some ","factorial primes",":","n! - 1",",","n", "=", "...", sep = " ") 
  
  # case 2: calling another method
  
  myplot <- function(x,y,...) { 
    
    z <- 2*x^2 - y
    
    plot(x, z,...) # the ... argument from myplot() is passed into the plot() function, which in turn passes it onto the graphic device;
  }                # it is evaluated not by the plot() function, but by another routine
  
  # example of case 2
  myplot(1:100, 2, 
         type = "l", col = "red", xlab = "x val", ylab = "2*x - y")
  
  
  
# 2 Scoping -----------------------------------------------------------------
  
# Scoping is a set of rules that govern how free variables are searched when not immediately defined.
  
## 2a. Consider the function

f <- function(x, y) {
  
    x^2 + y / z 
  
  }

# x and y are inserted by user, but how will R search for z (free variable) ?

  
# 2b. basic example of variable scoping

z <- 999

f <- function() {
  
  z <- 1
  y <- 2 
  
  c(z,y)
  
}

# what is the expected value of f()?
f()

# It is (1,2) because the local environment defined by f() already contains z, so R will not look up one level (the global environment)
# where z is also defined. 


## 2c. another example of scoping

x <- 1
y <- 999

h <- function(){
  
  y <- 2
  
  g <- function() {
    
     z <- 3
     
     c(x,y,z)
  }
  
  g()
}


h()
# We'd expect the answer (1,2,3). The value of y is undefined within the environment of g(), therefore R will
# search one level up to the parent environment of h() where y is defined. 


## 2d. example: putting x in different places

x <- "level 0"        # 0

main_f <- function() {
  
 x <- "level 1"       # 1
 y <- 2
  
  sub_f <- function() {
    
    x <- "level 2"    # 2
    z <- 3
    
    c(x,y,z)
    
  }
  
  x <- "level 3"       # 3   
  
  return(sub_f())
  
}

main_f()
# If x were not defined in sub_f(), R will go to the parent environment engendered by main_f(), where x is defined
# twice. In this situation, x will take on the value "level 3" (line 163) and NOT "level" 2 (line 151),
# since the latter is being overwritten in the same environment. 


## 2e. same concept with functions
# point: functions are first-class objects in R; they obey the same scoping rule as variables. 

f1 <- function(x) x 

f2 <- function() {
  
  f1 <- function(x) x^2
  
  f1(10)
  
}

f2()



# 3: anonymous functions --------------------------------------------------

# meaning: a function without name or assignment of output
# purpose: make small functions that are not worth naming or storing. often used in the apply() family

# 3a: example
(function(x) x + 3)(10) # declaration and the call in one line statement

# the above is the same as 
f <- function(x) x + 3 # declaration
f(10)                  # call


# 3b: components
formals((function(x) x + 3))
body((function(x) x + 3))
environment((function(x) x + 3))


# 3c: use on apply family

data <- as.matrix(replicate(3, rnorm(10))) # generate random data so apply() can be used


# normal way
fun <- function(x) {
  MAD <- median(abs(x - median(x))) 
 
}

apply(data, 2, fun)


# via anonymous function
apply(data, 2, function(x) median(abs(x - median(x))) )
 


