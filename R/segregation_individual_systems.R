segregation_individual_systems <- function(M=NULL, Ci=NULL, diagzero=TRUE, negzero=TRUE) {
# DESCRIPTION:
#    Calculate single system's segregation.
#
#  Inputs:   M,         Correlation matrix 
#            Ci,        Community affiliation vector (e.g., system labels)
#            diagzero, 	Boolean for setting diagonal of input matrix to 0. Default=TRUE
#            negzero,  	Boolean for setting negative edges of input matrix to 0. Default=TRUE
# 
#  Outputs:  segresult  Dataframe with rows = systems, and columns as follow:  
#            W,   Average of the mean correlation between nodes within the same
#                 community
#            B,   Average of edges between nodes from one commmunity to different 
#                 to all nodes in different communities
#            seg, System segregation of a single system

# ##########################################################################
#   Reference: Chan et al. (2014) PNAS E4997
#   Micaela Chan, UTD
# #########################################################################

  # warnings
  if(!isSymmetric.matrix(M, check.attributes = FALSE)) stop('Input matrix must be symmetric.')
  if(dim(M)[1]!=length(Ci)) stop('Length of community vector does not match matrix dimension.')

  if(diagzero==TRUE){ # set diagonal to 0 if True
    diag(M) <- 0
  }
  
  if(negzero==TRUE){  # set negative to 0 if True
    M[which(M<0)] <- 0
  }
  
  UniqueCi <- sort(unique(Ci))
  UniqueCi <- UniqueCi[which(UniqueCi>0)] # 

  segresult <- data.frame(Ci=UniqueCi,
                          W_ind=matrix(NA,length(UniqueCi)), # initializing final result data frame
                          B_ind=matrix(NA,length(UniqueCi)),
                          seg_ind=NA)
  for(i in 1:length(UniqueCi)){ # Loop through system
  
    w.index <- which(Ci==UniqueCi[i])
    b.index <- which(Ci!=UniqueCi[i])
    
    w.mat <- M[w.index, w.index]
    segresult$W_ind[i] <- mean(w.mat[upper.tri(M[w.index, w.index],diag=FALSE)],na.rm=TRUE) 
    segresult$B_ind[i] <- mean(M[w.index, b.index], na.rm=TRUE)         
  }
  
  # Calculating segregation 
  segresult$seg_ind <- (segresult$W_ind-segresult$B_ind)/segresult$W_ind

  return(segresult)
}
