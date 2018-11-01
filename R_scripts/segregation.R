# DESCRIPTION:
#   The degree to which edges are more dense within communites and more 
#   sparse between communities, which quantifies the segregation of a 
#   weighted network (Chan et al. 2014). 
#  
#  Inputs:   M,		correlation matrix 
#            Ci,	community affiliation vector 
#  Optional: 
#		diagzero, 	booleen for setting diagonal of input matrix to 0. 
#					Default=TRUE
#		negzero, 	booleen for setting negative edges of input matrix 
#					to 0. Default=TRUE
#
#  Outputs: segresult$S,    System segregation calcualted with W & B                 
#           segresult$W,    mean correlation between nodes within the same
#                    		community     
#           segresult$B,    mean correlation obetween nodes from different
#                    		community   
# #########################################################################
#   Reference: Chan et al. (2014) PNAS E4997
#   2018
#   Micaela Chan, UTD
#
#   Modification History:
#   May 2018: original
#   Oct 2018: commented script
########################################################################### 
segregation <- function(M=NULL, Ci=NULL, diagzero=TRUE, negzero=TRUE) {

  if(!isSymmetric.matrix(M)) stop('Input matrix must be symmetric.')
  if(dim(M)[1]!=length(Ci)) stop('Length of community vector does not match matrix dimension.')
  
  # Set diagonal to 0
  if(diagzero==TRUE){
    diag(M) <- 0
  }
  
  # Set negatives to 0
  if(negzero==TRUE){
    M[which(M<0)] <- 0
  }
  
  within <- vector(mode = "numeric")
  between <- vector(mode = "numeric")
  
  Ci_order <- sort(unique(Ci))
  segresult <- list()
  
  for(i in 1:length(Ci_order)){ # loop through communities
    network <- Ci_order[i]
    
    ww = M[Ci==network,Ci==network]		# find index for within communitiy edges
    bb = M[Ci==network,which(Ci!=network)]	# find index for within communitiy edges
    
    within <- append(within, ww[upper.tri(ww)])
    between <- append(between, as.vector(bb))  
  }
  
  segresult$W <- mean(within)	# mean within community edges
  segresult$B <- mean(between)	# mean between community edges
  segresult$S <- (segresult$W-segresult$B)/segresult$W # calculate system segregation
  
  return(segresult)
}