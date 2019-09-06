function [fig] = colormap_roi(mat, sorting, label, varargin)
% DESCRIPTION:
%   Make figure of matrix, with option to sort by community label. 
%   * Note that if the matrix is already sorted (organized by labeled 
%     community, the sorting option should be set to 2 so it won't re-sort 
%     the same matrix.
%   * Additional options to set min/max value of the matrix dipslayed, or
%   saving hte figure (png). If any optional argument is used, unused
%   optional arguments should be set to empty (e.g., []). 
%
% USAGE
% 1. simplest form: 
%       colormap_roi(raw_matrix, 1, label);
%       colormap_roi(sorted_matrix, 2, label);
% 2. Use optional argument to restrict min/max values:
%       colormap_roi(un_sorted_matrix, 1, label, -.2,2,[],[],[],[])
% 3. Use all optional arguments: 
%   colormap_roi(unsorted_matrix, 1, label, -.075, .075,'jet','Matrix title',1,'graph.png')
% 
% Inputs:   mat,            matrix to be saved as figure (e.g., 441x441 mat)
%           sorting,        1 = sort matrix so nodes with same label are 
%                           grouped together; 2 = no sorting
%           label,          vector of community label (matchs mat
%                           dimension; 441x1)
% OPTIONAL: 
%           minr,           minimum on graph
%           maxr,           maximum on graph
%           colormapcol,    color pallete for the colormap (default='jet')
%           titletext,      title for the figure
%           savefig,        save an output figure or not (1 = yes)
%           outfile,        output file 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   myc 12/2018 - initial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(varargin)
    minr=varargin{1,1};
    maxr=varargin{1,2};
    colormapcol=varargin{1,3};
    titletext=varargin{1,4};
    savefig=varargin{1,5};
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
% ~~~ Make figrue ~~~ %
fig = figure('Color',[1 1 1]);
set(fig, 'Position', [0 0 900 800])
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
t1 = text(zeros(length(ticklocation),1), ticklocation, num2str(u),'HorizontalAlignment','right','VerticalAlignment','middle','FontSize',12);
for j = 1:length(u)
    set(t1(j),'Color', [0 0 0]);
end


set(gca,'XTick',ticklocation); % X-Ticks
set(gca,'XtickLabel',[]);
t2 = text(ticklocation, repmat(size(mat,1),length(ticklocation),1),num2str(u),'VerticalAlignment','top','FontSize',12);
for k = 1:length(u)
    set(t2(k), 'Color', [0 0 0]);
end

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

