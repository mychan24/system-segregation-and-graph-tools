function matfig(mat, label, labelmeta, outfile, sorting)
% DESCRIPTION:
%   Save matrix sorted by network label. 
%
% Inputs:   mat,            matrix to be saved as figure
%           networklabel,   3 column cell array
%                               - label number        
%                               - label text  
%                               - [R G B]
%           outfile,        path to where figure is saved
%           sorting,        1 = need to sort, 2= don't sort
% Outputs:  
%
% ==== SAMPLE networklabel ====
%     networklabel = {2, '2 Ventral Frontal Temporal', [.502 .502 .502];
%                 3, '3 Default', [1 0 0];
%                 4, '4 Hand Somatosensory-motor', [0 1 1];
%                 5, '5 Visual', [0 0 1];
%                 6, '6 Fronto-Parietal Task Control', [.961 .961 .059];
%                 7, '7 Ventral Attention', [0 .502 .502];
%                 8, '8 Caudate-Putamen', [0 .275 .157];
%                 9, '9 Superior Temporal Gyrus', [1 .722 .824];
%                 10, '10 Inferior Temporal Pole', [.675 .675 .675];
%                 11, '11 OFC', [.373 .373 .373];
%                 12, '12 Inferior Anterior Insula', [.824 .824 .824];
%                 13, '13 Frontal Pole', [.627 .627 .627];
%                 14, '14 Cingulo-Opercular Task Control', [.502 0 .502];
%                 15, '15 Dorsal Attention', [0 .863 0];
%                 16, '16 Mouth Somatosensory-motor', [1 .502 0];
%                 17, '17 Lateral Temporal Pole', [.863 .863 .863];
%                 19, '19 Lateral Occipito-temporal', [.353 .353 .353];
%                 20, '20 Salience', [0 0 0];
%                 21, '21 Unkown Medial-temporal-parietal', [1 .973 .706];
%                 22, '22 Unkown Memory Retrieval', [0 .424 1];
%                 23, '23 Hippocampus', [0 .157 .314];
%                 24, '24 Auditory', [1 0 1];
%                 25, '25 Inferior Insula', [.773 .773 .773];
%                 26, '26 Unkown similar to Nelson2010', [1 .706 .353]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   myc 12/2018 - initial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(sorting==1) % Need sorting
    smat = mat(label, label);
else
    smat = mat;
end
fig = figure;
set(fig, 'Position', [0 0 1000 500])
colormap('jet')
imagesc(smat)

% Exclude systems with no ROIs
u = unique(label);
in_network = ismember(cell2mat(labelmeta(:,1)),u);
labelmeta_excluded = labelmeta(in_network,:); % labelmeta_excluded means systems shouldn't be included is excluded


ticklocation = zeros(length(u),1);

% Get index to draw line
for i = 1:length(u);
    l = sum(histc(label,u(1:i)));

    line([l+0.5 l+0.5], [0 length(label)],'Color','r');
    line([0 391], [l+0.5 l+0.5],'Color','r');

     ll = l-sum(histc(label,u(1:i-1)));    
     ll = ll/2;
     ticklocation(i) = int16(l-ll);
end

% initialize ticks
ticklocation = zeros(10,1);
for m = 1:length(labelmeta)
    ticklocation(m) = m;
end

set(gca,'YTick',ticklocation); % Set Ytick to be in the middle of a network
set(gca,'YtickLabel',[]);
t1 = text(zeros(length(ticklocation),1), ticklocation, labelmeta(:,1),'HorizontalAlignment','right','VerticalAlignment','middle');
for j = 1:length(labelmeta)
    set(t1(j), 'Color', cell2mat(labelmeta(j,3)));
end


set(gca,'XTick',ticklocation); % Set Xtick to be in the middle of a network
set(gca,'XtickLabel',[]);
t2 = text(ticklocation, repmat(size(mat,1)+1,length(ticklocation),1),labelmeta(:,1),'VerticalAlignment','top');
for k = 1:length(labelmeta)
    set(t2(k), 'Color', cell2mat(labelmeta(k,3)));
end

colorbar; minr = -.10; maxr = .10;
set(gca, 'CLim', [minr, maxr]);
printpng(fig, outfile)
