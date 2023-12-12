segregation_by_type_eqcont <- function(M=NULL, Ci=NULL, C_Type=NULL, diagzero=TRUE, negzero=TRUE) {
# DESCRIPTION:
#    Calculate versions of system segregation based on system-type (e.g., 
#    average segregation of systems of a certain 'type' to systems of any
#    type, from other systems of the same 'type,' and from systems of all
#    other types). 
#    ** In this version, the contribution of each 'system' is the same regardless of its size. 
#    This is the version used in Chan et al. 2014 PNAS.
#
#  Inputs:   M,         Correlation matrix 
#            Ci,        Community affiliation vector (e.g., system labels)
#            C_Type,    Community type vector (e.g., sensory-motor, association). 
#                       A node with type '0' is ignored when calculating segregation between 
#					              other types of systems (B_other/seg_othertype)
#            diagzero, 	Boolean for setting diagonal of input matrix to 0. Default=TRUE
#            negzero,  	Boolean for setting negative edges of input matrix to 0. Default=TRUE
# 
#  Outputs:  segresult  Dataframe with rows = systems, and columns as follow:  
#            W_same,    Average of the mean correlation between nodes within the same
#                       community of one system type
#            B_all,     Average of edges between nodes from different communities
#                       in all system types 
#            B_same,    Average of edges between nodes from different communities
#                       in the same system type
#            B_other,   Average of edges between nodes from different communities
#                    	  in the other system type
#            seg_all,  	For each system-type, the average segregation from all
#                   	  other communities that have an assigned system-type 
#                       e.g., average segregation of association systems to
#                       other association systems and sensory-motor system)
#            seg_same,  For each system-type, the average segregation from
#                   	  communities of the same type 
#                       e.g., average association-to-association system segregation.
#            seg_other, For each system-type, the average segregation from 
#                   	  communities of all other types 
#                       e.g., average association-to-sensory-motor system segregation.
# ##########################################################################
#   Reference: Chan et al. (2014) PNAS E4997
#   2017-2018
#   Micaela Chan, UTD
#
#   Modification History:
#   Sep 2017: original (MYC)
#   Oct 2018: Commented script (MYC)
# #########################################################################

  # warnings
  if(!isSymmetric.matrix(M, check.attributes = FALSE)) stop('Input matrix must be symmetric.')
  if(dim(M)[1]!=length(Ci)) stop('Length of community vector does not match matrix dimension.')
  if(dim(M)[1]!=length(C_Type)) stop('Length of community type vector does not match matrix dimension.')
  
  if(diagzero==TRUE){ # set diagonal to 0 if True
    diag(M) <- 0
  }
  
  if(negzero==TRUE){  # set negative to 0 if True
    M[which(M<0)] <- 0
  }
  
  UniqueType <- sort(unique(C_Type))
  UniqueType <- UniqueType[which(UniqueType>0)] # 

  segresult <- data.frame(W_same=matrix(NA,length(UniqueType)), # initializing final result data frame
                          B_all=matrix(NA,length(UniqueType)),  
                          B_same=matrix(NA,length(UniqueType)),
                          B_other=matrix(NA,length(UniqueType)))
  
  for(i in 1:length(UniqueType)){ # Loop through system-type
  
    type_i <- which(C_Type==UniqueType[i])
    Ci_specific <- unique(Ci[C_Type==UniqueType[i]])
    Ci_result <- data.frame(W_same=matrix(NA,length(Ci_specific)), # initializing system-specific data frame
                            B_all=matrix(NA,length(Ci_specific)),  
                            B_same=matrix(NA,length(Ci_specific)),
                            B_other=matrix(NA,length(Ci_specific)))
    
    othertype_i <- which(C_Type!=UniqueType[i] & C_Type!=0) # find index of communities not in current system-type (ignoring nodes not in either system types [i.e., '0']).
    
    for(j in 1:length(Ci_specific)){ # Loop through each community within current system-type
        w.index <- as.vector(which(Ci==Ci_specific[j])) # find index of a single community within current system-type
        b.index <- intersect(type_i, as.vector(which(Ci!=Ci_specific[j]))) # find index of other communities within current system-type
		
        w.mat <- M[w.index, w.index]
        Ci_result$W_same[j] <- mean(w.mat[upper.tri(M[w.index, w.index],diag=FALSE)],na.rm=TRUE) # average within-community 
        Ci_result$B_all[j] <- mean(M[w.index, c(b.index, othertype_i)], na.rm=TRUE) # average between-community with other communities (same or diff type)        
        Ci_result$B_same[j] <- mean(M[w.index, b.index],na.rm=TRUE)  # average between-community with same-type of communities 		
        Ci_result$B_other[j] <- mean(M[w.index, othertype_i],na.rm=TRUE) # average between-community with other-type of communities        
    }
    
    segresult[i,] <- colMeans(Ci_result, na.rm=TRUE)
  }
  
  # Calculating segregations (all, same-type, other-type)
  segresult$seg_all <- (segresult$W_same-segresult$B_all)/segresult$W_same
  segresult$seg_same <- (segresult$W_same-segresult$B_same)/segresult$W_same
  segresult$seg_other <- (segresult$W_same-segresult$B_other)/segresult$W_same
  
  row.names(segresult) <- UniqueType
  return(segresult)
}
