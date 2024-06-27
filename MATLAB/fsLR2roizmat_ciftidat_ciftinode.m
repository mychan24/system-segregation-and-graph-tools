function [z, r, tp] = fsLR2roizmat_ciftidat_ciftinode(cii, roi_cii)
% DESCRIPTION:
%   Extract node time series from 32k by 32k fsLR saved in CIFTI dtseries. 
%   Outputs correlation matrix (r), fishers-z-transfromed corr matrix (z),
%   and node-by-timepoint matrix (tp). 
%   
%   Nodes are L & R GIFTI files.
%
%   If running in MATLAB 2018+ addpath GIFTIv1_8

% --- Addpaths should be moved outside of this script ----
% addpath /cvl/wig/data/resources/tools/software/cifti-matlab
% addpath /cvl/wig/data/resources/tools/general_analysis/gifti_v1_8
% ----------% 


% % Load ROIs
if ischar(roi_cii) % check if roi is a file name or gifti object
    roi_cii = cifti_read(roi_cii); 
end
roi = roi_cii.data;

structnames={};
for i = 1:length(cii.diminfo{1}.models)
    structnames = [structnames {cii.diminfo{1}.models{i}.struct}];
end

i_left = strcmp(structnames, 'CORTEX_LEFT');
i_right = strcmp(structnames, 'CORTEX_RIGHT');

% LEFT
cstart_L = cii.diminfo{1}.models{i_left}.start;
cend_L = cii.diminfo{1}.models{i_left}.count + cstart_L - 1;
cL = cii.cdata(cstart_L:cend_L,:);

% RIGHT
cstart_R = cii.diminfo{1}.models{i_right}.start;
cend_R = cii.diminfo{1}.models{i_right}.count + cstart_R - 1;
cR = cii.cdata(cstart_R:cend_R,:);

% --- ---------------- ----


% Left Hemisphere
clm = zeros(length(uroiL),size(cL,2)); %Left

for j = 1:length(uroiL) % loop ROIs
    vert_in_node_L=find(roiL==uroiL(j))-1; % minus 1 since vertex count starts from 0        
    clm(j,:) = mean(cL(ismember(cii.diminfo{1}.models{i_left}.vertlist,vert_in_node_L), :));
end

% Right Hemisphere    
uroiR = unique(roiR);
uroiR=uroiR(uroiR~=0);    
crm = zeros(length(uroiR),size(cR,2)); %Right    

for k = 1:length(uroiR) % loop ROIs
    vert_in_node_R=find(roiR==uroiR(k))-1; % minus 1 since vertex count starts from 0        
    crm(k,:) = mean(cR(ismember(cii.diminfo{1}.models{i_right}.vertlist,vert_in_node_R), :));
end

tp = [clm;crm]; % Combine left and right
r = corrcoef(tp'); % Correlation matrix
z = 0.5 * log((1+r)./(1-r)); % Fisher-z transform


end % function

