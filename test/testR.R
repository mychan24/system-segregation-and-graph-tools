# Testing for segregation script

## Source scripts
source("./R_scripts/segregation.R")
source("./R_scripts/segregation_by_type.R")
load('./test/testanswer.RData')

pass <- list()

#### 1. Test segregation() ####
m <- matrix(NA,4,4)   # Create test data
m[1,] <- c(1,4,2,2)
m[2,] <- c(4,1,3,2)
m[3,] <- c(2,3,1,8)
m[4,] <- c(2,2,8,1)

ci <- c(1,1,2,2)      # Test community assignment

out <- segregation(M = m, Ci = ci,diagzero = T, negzero = T)

if(!identical(out, seg_c)){
  message("[2] ERROR! segregation() returned incorrect result. Check source code")
  pass[[1]] <- FALSE
}else{
  message("[1] PASSED: segregation() returned the correct test results.")
  pass[[1]] <- TRUE
}

#### 2. Test segregation_by_type() ####
ci <- c(1,1,2,2,3,3,4,4)
c_type <- c(3,3,3,3,2,2,2,2) # make Ci in an order thta has be sorted

m <- matrix(NA,8,8)
m[1,] <- c(1,0,0,0,1,1,0,1)
m[2,] <- c(0,1,2,2,2,2,0,2)
m[3,] <- c(0,2,1,4,1,4,2,2)
m[4,] <- c(0,2,4,1,0,2,2,2)
m[5,] <- c(1,2,1,0,1,4,0,0)
m[6,] <- c(1,2,4,2,4,1,1,1)
m[7,] <- c(0,0,2,2,0,1,1,0)
m[8,] <- c(1,2,2,2,0,1,0,1)


out_type <- segregation_by_type(M = m, Ci = ci, C_Type = c_type, diagzero = T, negzero = T)

if(!identical(out_type, seg_type_c)){
  message("[2] ERROR! segregation_type() returned incorrect result. Check source code")
  pass[[2]] <- FALSE
}else{
  message("[2] PASSED: segregation_type() returned the correct test results.")
  pass[[2]] <- TRUE
}

pass




