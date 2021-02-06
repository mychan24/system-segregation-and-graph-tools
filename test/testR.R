# Testing for segregation script

## Source scripts
source("./R_scripts/segregation.R")
source("./R_scripts/segregation_by_type.R")

# Load test data
# m <- as.matrix(read.table("./test/testmat1.txt",header=F, sep=","))
# ci <- read.table("./test/ci1.txt",header=F)$V1

## Define correct answer
coranswer <- list()
coranswer$W <- 6
coranswer$B <- 2
coranswer$S <- 0.625

m <- matrix(NA,4,4)
m[1,] <- c(1,4,2,2)
m[2,] <- c(4,1,3,2)
m[3,] <- c(2,3,1,8)
m[4,] <- c(2,2,8,1)

ci <- c(1,1,2,2)


##### 1. Test segregation() ####
out <- segregation(M = m, Ci = ci,diagzero = T, negzero = T)

if(!identical(out, coranswer)){
  print("ERROR! segregation() returned incorrect result. Check source code")
}else{
  print("segregation() returned the correct test results.")
}

# #### 2. Test segregation_by_type() ####
coranswer <- list()
coranswer$W <- 6
coranswer$B <- 2
coranswer$S <- 0.625

ci <- c(1,1,2,2,3,3,4,4)
c_type <- 

m <- matrix(NA,8,8)
m[1,] <- c(1,4,2,2,4,4,2,2)
m[2,] <- c(4,1,3,2,2,2,4,4)
m[3,] <- c(2,3,1,8,1,4,2,2)
m[4,] <- c(2,2,8,1,4,2,2,2)
m[5,] <- c(4,2,1,4,1,4,2,1)
m[6,] <- c(4,2,4,2,4,1,1,1)
m[7,] <- c(2,4,2,2,2,1,1,2)
m[8,] <- c(2,4,2,2,1,1,2,1)


segregation_by_type(M = m, Ci = c, C_Type = , diagzero = T, negzero = T)




















