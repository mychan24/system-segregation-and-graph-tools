# System Segregation (graph measure) scripts in R and Matlab

Scripts useful for doing Resting-state Functiaonl Correlation (RSFC) network analysis

**./matlab_scripts**
*  fsLR2roizmatrix.m - extract mean RSFC time-series from ROIs on fs_LR surfaces, outputs correlation matrix. 
*  mat2cytoscape.m  - convert correlation matrix to 3-column format used for visulization in Cytoscape.
*  segregation.m  -  calculates system segregation (Chan et al. 2014). 
*  segregation_systype.m  -  calculates segregation of specific system types (e.g., Sensory-motor, Association). 
*  ./export/ - includes scripts to save node-x-node matrix as figures.

**./R_scripts**
*  segregation.R  -  calculates system segregation (Chan et al. 2014). 
*  segregation_by_type.R  -  calculates segregation of specific system types (e.g., Sensory-motor, Association). 
*  for visualization of matrices and networks in R, see other repository [r-for-brain-network](https://github.com/mychan24/r-for-brain-network)
