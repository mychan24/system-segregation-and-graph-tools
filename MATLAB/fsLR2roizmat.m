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
%           roiL,       gifti file of ROIs on L hemisphere. Each ROI is 
%			either on separate column in the gifti file 
%			or in all ROIs are on a single column, with each 
%			number representing a different ROI.
%           roiR,      	gifti file of ROIs on R hemisphere
%           
% Outputs:  z,      Fisher-z-transformed correlation matrix.
%           r,      Corrleation r-matrix (Pearson's r). Need to normalized 
%                   before analysis can be run on r-matrix. 
%           tp,     roi x timepoint matrix (each column is the mean signal
%                   of the vertices within each ROI at that frame).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   myc 08/2019 - Detect if roi input is single/multiple columns.
%   myc 11/2018 - change roi flag from ==1 to ~=0
%   myc 10/2018 - commented script
%   myc 10/2016 - Initial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Load data GIFTIs
if ischar(gL) % check if is a file name or gifti object
    disp('Input is a filepath')
    gL = gifti(gL);
    gL = gL.cdata;
    gR = gifti(gR);
    gR = gR.cdata;
elseif isa(gL, 'gifti')
    disp('Input is a gifti object')
    gL = gL.cdata;
    gR = gR.cdata;
elseif isa(gL,'float')
    disp('Input is a numerical matrix')
    % do nothing if it is already a vector
else
    print('wrong object class for input gifti')
end

% % Load ROIs
if ischar(roiL) % check if roi is a file name or gifti object
    roiL = gifti(roiL); % load gifti if it is a file name
    roiR = gifti(roiR);
end
roiL = roiL.cdata;
roiR = roiR.cdata;

if(size(roiL,2)>1)
    % If ROIs are defined by separate columns
    
    glm = zeros(size(roiL,2),size(gL,2)); %Left
    grm = zeros(size(roiR,2),size(gR,2)); %Right       
    for j = 1:size(roiL,2) % loop ROIs
        glm(j,:) = mean(gL(roiL(:,j)~=0, :));
    end

    for k = 1:size(roiR,2)
        grm(k,:) = mean(gR(roiR(:,k)~=0, :));
    end
else
    % If ROIs are defined by 1 column of different number index 
    uroiL = unique(roiL);    
    uroiL=uroiL(uroiL~=0);
    
    uroiR = unique(roiR);
    uroiR=uroiR(uroiR~=0);
    
    glm = zeros(length(uroiL),size(gL,2)); %Left
    grm = zeros(length(uroiR),size(gR,2)); %Right     
    
    for j = 1:length(uroiL) % loop ROIs
        glm(j,:) = mean(gL(roiL(:,1)==uroiL(j), :));
    end
    
    for k = 1:length(uroiR) % loop ROIs
        grm(k,:) = mean(gR(roiR(:,1)==uroiR(k), :));
    end
end

tp = [glm;grm]; % Combine left and right
r = corrcoef(tp'); % Correlation matrix
z = 0.5 * log((1+r)./(1-r)); % Fisher-z transform
    
end


