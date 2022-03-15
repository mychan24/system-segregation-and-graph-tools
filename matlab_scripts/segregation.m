function [S, W, B] = segregation(M, Ci, varargin) 
% DESCRIPTION:
%   The degree to which edges are more dense within communites and more 
%   sparse between communities, which quantifies the segregation of a 
%   weighted network (Chan et al. 2014). 
%
% USAGE: 
%   S = segregation(M,Ci)
%   [S, W, B] = segregation(M,Ci)
%
% Inputs:   M:      weighted symmetrical matrix (n x n matrix)
%
%           Ci:     community affiliation vector (n x 1 vector)
%
%     (OPTIONAL)
%         diagzero: Convert diagonal to zero (e.g., if matrix has InF in 
%                     diagonal). Enter 'diagzero'.
%
%         negzero:  Convert negative values to zero. Enter 'negzero'
%
% Outputs:  S:      System segregation calcualted with W & B
%
%           W:      mean edge weight between nodes within the same
%                   community
%
%           B:      mean edge weight obetween nodes from different
%                   community
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Reference: Chan et al. (2014) PNAS E4997
%   2014-2022
%   Micaela Chan, UTD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Check inputs
if length(Ci)~=length(M)
        error('Length of label does not match with matrix dimension.');
end

if numvarargs > 2
    error('segregation_by_type_prcont:TooManyInputs', ...
        'requires at most two optional inputs');
end
 
nCi = unique(Ci);
Wv = [];
Bv = [];

% Set diagonal/negatives to zero if specified
if(sum(ismember(varargin, 'diagzero'))>0)
M(1:1+size(M,1):end) = 0;
end

if(sum(ismember(varargin, 'negzero'))>0)
M(M<0) = 0;
end 

for i = 1:length(nCi) % loop through communities
   Wi = Ci == nCi(i); % find index for within communitiy edges
   Bi = Ci ~= nCi(i); % find index for between communitiy edges
   
   Wv_temp = M(Wi,Wi); % extract within communitiy edges
   Bv_temp = M(Wi,Bi); % extract between communitiy edges
      
   Wv = [Wv, Wv_temp(logical(triu(ones(sum(Wi)),1)))'];  
   Bv = [Bv, Bv_temp(:)'];
end

W = mean(Wv); % mean within community edges
B = mean(Bv); % mean between community edges
S = (W-B)/W; % system segregation