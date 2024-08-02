function [z, r, tp] = fsLR2roizmat_ciftidat_ciftinode(cii, roi_cii)
% DESCRIPTION:
%   Extract node time series from 32k fsLR saved in CIFTI dtseries. 
%   Outputs correlation matrix (r), fishers-z-transfromed corr matrix (z),
%   and node-by-timepoint matrix (tp). 
%   
%   cii:        Full path to CIFIT data or CIFTI object
%
%   roi_cii:    Full path to nodes in CIFTI format or CIFTI object in
%   
%   requires: cifti-matlab
% ----------% 


% --- Load and setup ROIs ---
if ischar(roi_cii) % check if roi is a file name or gifti object
    roi_cii = cifti_read(roi_cii); 
end

roi_start_L=    roi_cii.diminfo{1}.models{1}.start;
roi_end_L =     roi_cii.diminfo{1}.models{1}.count + roi_start_L - 1;
roiL =          roi_cii.cdata(roi_start_L:roi_end_L);
uroiL = unique(roiL);
uroiL = uroiL(uroiL~=0);   

roi_start_R=    roi_cii.diminfo{1}.models{2}.start;
roi_end_R =     roi_cii.diminfo{1}.models{2}.count + roi_start_R - 1;
roiR =          roi_cii.cdata(roi_start_R:roi_end_R);
uroiR = unique(roiR);
uroiR=uroiR(uroiR~=0);    

% --- Load and setup data ---
if ischar(cii) % check if roi is a file name or gifti object
    cii = cifti_read(cii); 
end

% LEFT
cstart_L =  cii.diminfo{1}.models{1}.start;
cend_L =    cii.diminfo{1}.models{1}.count + cstart_L - 1;
cL =        cii.cdata(cstart_L:cend_L,:);

% RIGHT
cstart_R =  cii.diminfo{1}.models{2}.start;
cend_R =    cii.diminfo{1}.models{2}.count + cstart_R - 1;
cR =        cii.cdata(cstart_R:cend_R,:);


% Left Hemisphere
clm = zeros(length(uroiL),size(cL,2)); 

for j = 1:length(uroiL) % loop ROIs
    roi_index_from_vertlist_L=roi_cii.diminfo{1}.models{1}.vertlist(find(roiL==uroiL(j)));
    i_vert_in_roi_L = ismember(cii.diminfo{1}.models{1}.vertlist, roi_index_from_vertlist_L);  % find vertices in cdata based on model vertlist matching node's vertlist
    clm(j,:) = mean(cL(i_vert_in_roi_L, :));
end

% Right Hemisphere
crm = zeros(length(uroiR),size(cR,2));

for k = 1:length(uroiR) % loop ROIs
    roi_index_from_vertlist_R=roi_cii.diminfo{1}.models{1}.vertlist(find(roiR==uroiR(k)));
    i_vert_in_roi_R = ismember(cii.diminfo{1}.models{2}.vertlist, roi_index_from_vertlist_R);  % find vertices in cdata based on model vertlist matching node's vertlist
    crm(k,:) = mean(cR(i_vert_in_roi_R, :));
end

tp = [clm;crm]; % Combine left and right
r = corrcoef(tp'); % Correlation matrix
z = 0.5 * log((1+r)./(1-r)); % Fisher-z transform

end % function

