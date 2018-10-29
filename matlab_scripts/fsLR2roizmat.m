function [z, r, tp] = fsLR2roizmat(gL, gR, roiL, roiR)
% DESCRIPTION:
%   Extract ROI time series from 32k by 32k fsLR and save as correlation
%   matrix (r), fisher-z-transfromed correlation matrix (z), or
%   roi-by-timepoint matrix (tp). 
%   ROI needs to formatted where each column represents a separate ROI, 
%   where '1' indicates where an ROI is, '0' otherwise.
%    
%   Requires gifti toolbox: http://www.artefact.tk/software/matlab/gifti/)
%
% USAGE:
%   [z, r, tp] = fsLR2roizmat(gL, gR, roiL, roiR)
%
% Inputs:   gL,         gifti of subject's L fs_LR (32k x timepoint)
%           gR,         gifti of subject's R fs_LR (32k x timepoint)
%           roiL,       gifti file of ROIs on L hemisphere.
%           roiR,       gifti file of ROIs on R hemisphere, 
%                       with each ROI on separate column in the gifti file.
%          
%           
% Outputs:  z,      Fisher-z-transformed correlation matrix.
%           r,      Corrleation r-matrix (Pearson's r). Need to normalized 
%                   before analysis can be run on r-matrix. 
%           tp,     roi x timepoint matrix (each column is the mean signal
%                   of the vertices within each ROI at that frame).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   myc 10/2016 - original
%   myc 10/2018 - commented script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ischar(roiL) % check if roi is a file name or gifti object
    roiL = gifti(roiL); % load gifti if it is a file name
    roiR = gifti(roiR);
end

roiL = roiL.cdata;
roiR = roiR.cdata;

%Left
if ischar(gL) % check if is a file name or gifti object
    gL = gifti(gL);
    gL = gL.cdata;
    gR = gifti(gR);
    gR = gR.cdata;
elseif isa(gL, 'gifti')
    gL = gifti(gL);
    gR = gifti(gR);
elseif isa(gL,'float')
    % do nothing if it is already a vector
else
    print('wrong object class for input gifti')
end

glm = zeros(size(roiL,2),size(gL,2)); % Left
for j = 1:size(roiL,2) % loop ROIs
    glm(j,:) = mean(gL(roiL(:,j)==1, :));
end
  
grm = zeros(size(roiR,2),size(gR,2)); % Right
for k = 1:size(roiR,2)
    grm(k,:) = mean(gR(roiR(:,k)==1, :));
end

tp = [glm;grm]; % Stack left and right to make roi x tp matrix
r = corrcoef(tp'); % Calculate correlation matrix
z = 0.5 * log((1+r)./(1-r)); % Fisher-z transform
    
end

