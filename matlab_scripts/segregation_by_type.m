function [ S_all, S_same, S_other] = segregation_by_type( M, Ci, Ti )
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% segregation_systype.m
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DESCRIPTION:
%    Calculate versions of system segregation based on system-type (e.g.,
%    average segregation of systems of a certain 'type' to systems of any
%    type, from other systems of the same 'type,' and from systems of all
%    other types; Chan et al. 2014).
%    Three vectors of length T (# of unique system-types) containing
%    different versions of segregation can be output based on the input
%    system-type affiliation vector.
%
% USAGE:
%    [ S_all, S_same, S_other ] = segregation_by_type( M, Ci, Ti );
%
% Inputs: M   :   Weighted symmetrical matrix (n x n matrix)
%                   e.g., fisher-z-transformed correlation matrix.
%
%         Ci  :   Community affiliation vector
%                   e.g., Power labels for Chan et al 441 nodes:
%
%         Ti  :   System-type affiliation vector containing T unique
%                 'types'; a nodes with a system-type label of '0' is
%                 ignored when calculating segregation from communities of
%                 other types (S_other).
%                   e.g., '1' for Sensory-motor, '2' for Association
%
% Outputs: S_all:   for each system-type, the average segregation from all
%                   other communities that have an assigned system-type
%                       e.g., average segregation of association systems to
%                       other association systems and sensory-motor system)
%
%          S_same:  for each system-type, the average segregation from
%                   communities of the same type
%                       e.g., average association-to-association system
%                       segregation.
%
%          S_other: for each system-type, the average segregation from
%                   communities of all other types
%                       e.g., average association-to-sensory-motor system
%                       segregation.
%
%    Note: Values in output vectors are ordered in ascending order of
%          system-type relative to the input vector Ti.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Reference: Chan et al. (2014) PNAS E4997
%   2015-2018
%   Neil Savalia, UTD
%   Micaela Chan, UTD
%
%   Modification History:
%   Dec 2015: original (NKS, MYC)
%   Oct 2018: took out warning for Inf diagonal (diagonal not used in
%             calculation; edited comments (MYC)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Check inputs
 if size(Ci, 1) ~= size(M, 1) || size(Ci, 1) ~= size(M, 2) > 0
     error('Length of community label index does not match with matrix dimension.');
 elseif size(Ti, 1) ~= size(M, 1) || size(Ti, 1) ~= size(M, 2) > 0
     error('Length of system-type label index does not match with matrix dimension.');
 elseif sum(sum(sum(isnan(M)))) > 0
     disp('Warning: NaN values detected in input data matrix, may result in some NaN segregation values.');
 end

 % Index of node affiliations (community & system-type)
 nCi = unique(Ci);
 nTi = unique(Ti(Ti > 0)); % do not include system-types labeled '0'

 S_all = zeros(size(nTi));
 S_same = zeros(size(nTi));
 S_other = zeros(size(nTi));

 % Calculate segregation
 for x = 1:size(nTi, 1) % for each system-type

     % get communities affiliations based on current system-type
     t = unique(Ci(Ti == nTi(x))); % list of communities in current type
     ot = unique(Ci(ismember(Ti, nTi(~ismember(nTi, nTi(x)))))); % list of communities of other type(s)

     % reset within and between values
     tM = [];
     w = [];
     b.all = [];
     b.same = [];
     b.other = [];

     % for each community in current type, get pieces to calculate seg
     for y = 1:size(t, 1)

         % node indices given the current community
         sys = ismember(Ci, nCi(nCi == t(y))); % nodes in current community
         same = ismember(Ci, t(t ~= (t(y)))); % nodes in communities of same 'type' as the current community
         other = ismember(Ci, ot); % nodes in communities of other 'type(s)' relative to current community

         % within and between values
         tM = M(sys, sys);
         w(y) = mean(tM(logical(triu(ones(size(tM)), 1))));
         b.all(y) = mean2(M(sys, logical(same + other)));
         b.same(y) = mean2(M(sys, same));
         b.other(y) = mean2(M(sys, other));

     end

     % calculate segregation
     % communities with a single node will return NaN segregation values
     S_all(x) = (mean(w, 2) - mean(b.all, 2))./mean(w, 2); % subject x system-type average seg to all other communities
     S_same(x) = (mean(w, 2) - mean(b.same, 2))./mean(w, 2); % subject x system-type average seg to communities of the same type
     S_other(x) = (mean(w, 2) - mean(b.other, 2))./mean(w, 2); % subject x system-type average seg to communities of other type(s)

 end

end
