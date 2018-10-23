function [S, W, B] = segregation(M, Ci) 
% DESCRIPTION:
%   The degree to which edges are more dense within communites and more 
%   sparse between communities, which quantifies the segregation of a 
%   weighted network (Chan et al. 2014). 
%
% USAGE: 
%   S = segregation(M,Ci)
%   [S, W, B] = segregation(M,Ci)
%
% Inputs:   M,      weighted symmetrical matrix (n x n matrix)
%           Ci,     community affiliation vector (n x 1 vector)
%
% Outputs:  S,      System segregation calcualted with W & B                
%           W,      mean edge weight between nodes within the same
%                   community     
%           B,      mean edge weight obetween nodes from different
%                   community  
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Reference: Chan et al. (2014) PNAS E4997
%   2014-2018
%   Micaela Chan, UTD
%
%   Modification History:
%   2014: original
%   Oct 2018: commented script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if length(Ci)~=length(M)
        error('Length of label does not match with matrix dimension.');
end

nCi = unique(Ci);
Wv = [];
Bv = [];

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