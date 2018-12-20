function [fig] = colormap_roi(mat, sorting, label, labelmeta, varargin)
% DESCRIPTION:
%   Save matrix sorted by network label. 
% USAGE
% colormap_roi(sorted_matrix, 2, roifile);
% colormap_roi(sorted_matrix, 2, roifile, -.075, .075,'cool',1,'fig title','graph.png')
% colormap_roi(un_sorted_matrix, 1, roifile, '','','bone',0,'','')

% Inputs:   mat,            matrix to be saved as figure (e.g., 441x441 mat)
%           sorting,        1 = sort matrix so nodes with same label are 
%                           grouped together; 2 = no sorting
%           label,          vector of community label (matchs mat
%                           dimension; 441x1)
%           labelmeta,      3 column cell array
%                               - label number        
%                               - label text  
%                               - [R G B]
% OPTIONAL: 
%           minr,           minimum on graph
%           maxr,           maximum on graph
%           colormapcol,    color pallete for the colormap (default='jet')
%           savefig,        save an output figure or not (1 = yes)
%           titletext,      title for the figure
%           outfile,        output file 
% Outputs:  
%
% ==== SAMPLE networklabel ====
%     labelmeta = {2, '2 Ventral Frontal Temporal', [.502 .502 .502];
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
if ~isempty(varargin)
    minr=varargin{1,1};
    maxr=varargin{1,2};
    colormapcol=varargin{1,3};
    savefig=varargin{1,4};
    titletext=varargin{1,5};
    outfile=varargin{1,6};
else
    minr=0;
    maxr=1;
    colormapcol='jet';
    savefig=0;
    titletext='Matrix';
    outfile=[];
end

% ~~~  Load files/variables  ~~~ %
if isnumeric(label)
    display('label is vector');
else
    display('loading label file');
    label = load(label);
end

if(ischar(mat)==1)
    [~,~,ext]=fileparts(mat);
    if(strcmp(ext,'.mat'))
        mat = load(mat);
        fn = fieldnames(mat);
        fn = char(fn);
        fn = ['mat.' fn];
        mat = eval(fn);
    else
        mat = load(mat);
    end
end

if(size(mat,1)~=size(label,1))
    error('The size of the matrix does not match the number of ROI');
else
    fprintf('Loading %d by %d matrix \n',size(mat,1), size(mat,2));
end

% ~~~ sort matrix and label if needed ~~~ %
nn=length(label);
if(sorting==1) % Need sorting
    ss = sortrows([label, (1:nn)']);
    smat = mat(ss(:,2), ss(:,2));
else
    smat = mat;
end

u = unique(label);
in_network = ismember(cell2mat(labelmeta(:,1)),u); % Exclude labelmetafrows that don't have a value in label vector (e.g., hippocampus in power 2011 is not in 441 nodes)
labelmeta_excluded = labelmeta(in_network,:); % took out excluded label's row 

% ~~~ Make figrue ~~~ %
fig = figure('Color',[1 1 1]);
set(fig, 'Position', [0 0 1200 700])
colormap(colormapcol) % 'jet','cool' are not bad
imagesc(smat)

ticklocation = zeros(length(u),1);

% Get index to draw line
for i = 1:length(u);
    l = sum(histc(label,u(1:i)));
    
    line([l+0.5 l+0.5], [0 nn],'Color',[0 0 0], 'LineStyle','--');
    line([0 nn], [l+0.5 l+0.5],'Color',[0 0 0], 'LineStyle','--');

    ll = l-sum(histc(label,u(1:i-1)));    
    ll = ll/2;
    ticklocation(i) = int16(l-ll);
end


% ~~~ Set Title, X-ticks and Y-ticks ~~~ %
title(titletext); % Title
set(gca,'YTick',ticklocation);  % Y-Ticks
set(gca,'YtickLabel',[]);
t1 = text(zeros(length(ticklocation),1), ticklocation, labelmeta_excluded(:,1),'HorizontalAlignment','right','VerticalAlignment','middle','FontSize',12);
for j = 1:length(labelmeta_excluded)
    set(t1(j), 'Color', cell2mat(labelmeta_excluded(j,3)));
end


set(gca,'XTick',ticklocation); % X-Ticks
set(gca,'XtickLabel',[]);
t2 = text(ticklocation, repmat(size(mat,1),length(ticklocation),1),labelmeta_excluded(:,1),'VerticalAlignment','top','FontSize',12);
for k = 1:length(labelmeta_excluded)
    set(t2(k), 'Color', cell2mat(labelmeta_excluded(k,3)));
end


[legend_h, ~, ~, ~] = legend(labelmeta_excluded(:,2),'Location','BestOutside');
set(legend_h, 'Box', 'off')
set(legend_h, 'color', 'none')
objh=findobj(legend, 'type','line','linestyle','-');
set(objh,'visible','off')
legtxt=findobj(legend,'type','text');
legtxt = sort(legtxt); % reorder the reversed order legend txt index

colorbar
if(isempty(minr))
    minr = 0;
end
if(isempty(maxr))
    maxr = 1;
end

set(gca, 'CLim', [minr, maxr]);

if(savefig == 1 )
    printpng(fig, outfile)
end

end




function [filename] =  printpdf(fig, name)
% printpdf Prints image in PDF format without tons of white space

% The width and height of the figure are found
% The paper is set to be the same width and height as the figure
% The figure's bottom left corner is lined up with
% the paper's bottom left corner

% Set figure and paper to use the same unit
set(fig, 'Units', 'centimeters')
set(fig, 'PaperUnits','centimeters');

% Position of figure is of form [left bottom width height]
% We only care about width and height
pos = get(fig,'Position');

% Set paper size to be same as figure size
set(fig, 'PaperSize', [pos(3) pos(4)]);

% Set figure to start at bottom left of paper
% This ensures that figure and paper will match up in size
set(fig, 'PaperPositionMode', 'manual');
set(fig, 'PaperPosition', [0 0 pos(3) pos(4)]);

% Print as pdf
print(fig, '-dpdf', name)

% Return full file name
filename = [name, '.pdf'];
end


function [filename] =  printpng(fig, name)
% printpdf Prints image in PNG format without tons of white space

% The width and height of the figure are found
% The paper is set to be the same width and height as the figure
% The figure's bottom left corner is lined up with
% the paper's bottom left corner

% Set figure and paper to use the same unit
set(fig, 'Units', 'centimeters')
set(fig, 'PaperUnits','centimeters');

% Position of figure is of form [left bottom width height]
% We only care about width and height
pos = get(fig,'Position');

% Set paper size to be same as figure size
set(fig, 'PaperSize', [pos(3) pos(4)]);

% Set figure to start at bottom left of paper
% This ensures that figure and paper will match up in size
set(fig, 'PaperPositionMode', 'manual');
set(fig, 'PaperPosition', [0 0 pos(3) pos(4)]);
set(gcf,'InvertHardcopy','off')

% Print as png
print(fig, '-dpng', name)

% Return full file name
filename = [name, '.png'];
end

