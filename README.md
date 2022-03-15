[![Build Status](https://www.travis-ci.com/mychan24/system_matrix_tools.svg?branch=master)](https://www.travis-ci.com/mychan24/system_matrix_tools) [![DOI](https://img.shields.io/badge/DOI-10.1073%2Fpnas.1415122111-purple)](https://doi.org/10.1073/pnas.1415122111)

# System Segregation (graph measure) scripts in R and MATLAB

Scripts useful for doing Resting-state Functional Correlation (RSFC) network analysis

## Segregation calculations in R and MATLAB
**./R** or **./MATLAB**
*  `segregation.R/.m`  -  calculates system segregation (Chan et al. 2014). 
*  `segregation_by_type_prcont.R/.m`  -  calculates segregation of specific system types (e.g., Sensory-motor, Association), and letting system of different sizes to contribute proportionally based on their size (# of nodes). This is a similar method to `segregation.R/.m` for whole brain system segregation. 
*  `segregation_by_type_eqcont.R/.m`  -  calculates segregation of specific system types (e.g., Sensory-motor, Association), but first averaging within/between system connectivity for each individual system. This allows smaller systems to contribute more to the overall segregation value of that system type. This was how system-type segregation was calculated in Chan et al. (2014). 

## Utility  
**./MATLAB**
*  `fsLR2roizmatrix.m` - extract mean RSFC time-series from ROIs on fs_LR surfaces, outputs correlation matrix. 
*  `mat2cytoscape.m`  - convert correlation matrix to 3-column format used for visualization in Cytoscape.
*  ./export/ - includes scripts to save node-x-node matrix as figures.


*  for visualization of matrices and networks in R, see other repository [r-for-brain-network](https://github.com/mychan24/r-for-brain-network)
