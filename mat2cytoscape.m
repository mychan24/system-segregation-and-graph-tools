function [sep_sparse] = mat2cytoscape(m, outfile, neg, dia)
% DESCRIPTION: 
%   Convert symmetrical connection matrix to input data for Cytoscape
%   (i.e., 3 columsn: NodeID1, NodeID2, edge weight).
%
% USAGE: 
%   [sep_sparse] = mat2cytoscape(m, outfile, neg)
%
% Inputs:  
%       m:          symetrical connection matrix
%
%       outfile:    path and file name for csv file (use as input in
%                   cytoscape)
%
%       neg:        argument for whether to keep negative edges. 
%                   0 - include negative edges
%                   1 - set negative edges to zero
% 
%       dia:        argument for whether to set diagonal to '0'. 
%                   0 - don't alter diagonal
%                   1 - set diagonal to zero
% 
%   Note: It is easier for visualization in cytoscape to set diagonal to 
%   zero (as the diag is always 1/Inf (r/z-matrix), and not informative). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   myc 10/2015
%   myc 10/2018 - commented script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

if neg == 1 % set negative edges to 0
    m(m < 0) = 0;
end

if dia == 1 % set diagonal to 0
    m(logical(eye(size(m)))) = 0; 
end
    
b = sparse(m);
[i,j,val] = find(b);
sep_sparse = [i,j,val];

csvwrite(outfile,sep_sparse) % write 3-column output to csv file
