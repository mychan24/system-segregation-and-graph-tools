function map_to_gii(node_gii_file_L, node_gii_file_R, V, outfile_L, outfile_R)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION:
%   Map vector of values to gifti
%
% USAGE:
%   map_to_gii(pl_file, pr_file, outdir, subid)
%
% Inputs:   node_gii_file_L,    left nodes gifti file (single column)
%           node_gii_file_R,    right nodes gifti file (single column)
%           V,                  vector of values to be mapped to nodes
%           outfile_L,          output gifti file (L)
%           outfile_R,          output gifti file (R)
%           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MYC 201907016 - Initial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
node_L=gifti(node_gii_file_L);
node_R=gifti(node_gii_file_R);
    
output_L = zeros(size(node_L.cdata));
output_R = zeros(size(node_R.cdata));

i_L = max(node_L.cdata);

for i = 1:length(V)
    if i <= i_L     
        output_L(node_L.cdata==i)=V(i);
    else
        output_R(node_R.cdata==i)=V(i);
    end
end

output_gii_L = gifti(output_L);
output_gii_R = gifti(output_R);

output_gii_L.private.metadata(1).name='AnatomicalStructurePrimary';
output_gii_L.private.metadata(1).value='CortexLeft';

output_gii_R.private.metadata(1).name='AnatomicalStructurePrimary';
output_gii_R.private.metadata(1).value='CortexRight';

save(output_gii_L, outfile_L);
save(output_gii_R, outfile_R);
