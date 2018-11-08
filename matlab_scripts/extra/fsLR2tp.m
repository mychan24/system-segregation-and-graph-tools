function fsLR2tp(subj,gl_file,gr_file,tpdir,roil_file, roir_file)
addpath('/data/data4/MCHAN/tools/git/system_matrix_tools/matlab_scripts')
addpath('/data/data4/MCHAN/tools/git/gifti')

roil_gii = gifti(roil_file);
roir_gii = gifti(roir_file);

gl_1 = gifti(gl_file);
gr_1 = gifti(gr_file);
gl = gl_1.cdata;
gr = gr_1.cdata;

[~,~,tp] = fsLR2roizmat(gl, gr, roil_gii, roir_gii);

dlmwrite([tpdir subj '_441nodes_autoFS_x_tp.txt'], tp); % write out tp
    

end