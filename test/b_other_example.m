% Example of why B_other in eqcont segregation is not the same in across
% system types when there are only two system types

% create random 6x6 matrix
B = toeplitz(randi([0 9],6,1)); 


% assumeing 3 systems, 1:2, 3, 4:6
% assuming 2 systype, 1:3, 4:6

% between system wither others for system type 1
sys_type1_b_other_1 = mean(reshape((B(1:2,4:6)),[],1));
sys_type1_b_other_2 = mean(reshape((B(3,4:6)),[],1));
 
% between system wither others for system type 2
sys_type2_b_other_1 = mean(reshape((B(4:6,1:3)),[],1));
 
% These are not the same
((sys_type1_b_other_1 + sys_type1_b_other_2)/2) ~= sys_type2_b_other_1
 
 
% When there are only two system types, 
% calcualting b_other by combining all between_sys vertices across 
% all systems [proportional contribution approach], will yield the same 
% b_other for both system type. 
mean(reshape(B(1:3,4:6),[],1)) == mean(reshape(B(4:6,1:3),[],1))

