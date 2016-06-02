# options(error=recover)
# options(warn)
# traceback()
# debug() & undebug()
# browser() if there's no error
## Note that going next breaks out, but errors don't
# Look up trace()

# http://www.biostat.jhsph.edu/~rpeng/docs/R-debug-tools.pdf

f <- function(x) {
  r <- x - g(x)
  r
}
g <- function(y) {
  r <- y * h(y)
  r
}
h <- function(z) {
  r <- log(z)
  if (r < 10) 
    r^2 else r^3
}

f(-1)
# Setting a seed means random numbers are always the same
set.seed(1)

# Make list
# I didn't go through this with the group,
# but it's useful to debug functions you useful
# in apply functions
vec <- sample(1:10, 100, rep=T)
vec[sample(seq_along(vec), 1)] <- -1
vec <- as.list(vec)

lapply(vec, f)

## TRY

newf <- function(num){
  if(num < 0) stop("Number is not positive")
  num - 1
}



nums <- -1:10
#newlist <- list()
newlist <- vector(length(nums), mode = "list")
for(i in seq_along(nums)){
# try, silent = TRUE
	newlist[[i]] <- newf(nums[i])
	#newlist[[i]] <- try(newf(nums[i]), silent=T)

}

sapply(newlist, is)

