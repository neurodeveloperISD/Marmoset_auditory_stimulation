%% Initialize variables
% List of data files
arquivosTXT = dir( fullfile('.', '*.csv') );
arquivosTXT = {arquivosTXT.name}';

% Import data
for i=1:numel(arquivosTXT);
filename = arquivosTXT{i};
delimiter = ',';
startRow = 4;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
DATA {i}= textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
end
%% Clear temp variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Plot data 
j=0;i=0;
figure;hold on
for i=1:numel(arquivosTXT);
    subplot (5,4,i); hold
    DATA{1,i}{1,2}(DATA{1,i}{1,2}<=150)=NaN; 
    DATA{1,i}{1,2}(DATA{1,i}{1,2}>=800)=NaN;
    DATA{1,i}{1,3}(DATA{1,i}{1,3}<=150)=NaN; 
    DATA{1,i}{1,3}(DATA{1,i}{1,3}>=800)=NaN;
    scatter(DATA{1,i}{1,2},DATA{1,i}{1,3},'.')

    DATA{1,i}{1,5}(DATA{1,i}{1,5}<=150)=NaN
    DATA{1,i}{1,5}(DATA{1,i}{1,5}>=800)=NaN
    DATA{1,i}{1,6}(DATA{1,i}{1,6}<=150)=NaN;
    DATA{1,i}{1,6}(DATA{1,i}{1,6}>=800)=NaN;
    scatter(DATA{1,i}{1,5},DATA{1,i}{1,6},'.')
    
    DATA{1,i}{1,11}(DATA{1,i}{1,11}<=350)=NaN; 
    DATA{1,i}{1,11}(DATA{1,i}{1,11}>=1000)=NaN;
    DATA{1,i}{1,12}(DATA{1,i}{1,12}<=350)=NaN; 
    DATA{1,i}{1,12}(DATA{1,i}{1,12}>=1000)=NaN;
    scatter(DATA{1,i}{1,11},DATA{1,i}{1,12},'.')
    xlim([400 800]);ylim([200 800]);
end 

DATAXYZ=[]
for i=1:numel(arquivosTXT);% ObjectAx, ObjectAy variables for marmoset position
    DATAXY=[];
    DATAXY (:,1) = DATA{1,i}{1,11}; 
    DATAXY (:,2) = DATA{1,i}{1,12};
    DATAXY(any(isnan(DATAXY), 2), :) = [];
    DATAXYZ = cat(1,DATAXYZ,DATAXY);
end 

x = DATAXYZ(:,1);  % x position data
y = DATAXYZ(:,2);  % y position data
% Create a 2D histogram of the data
nbins = 40;  % bins in each dimension
[counts, edges] = hist3([x, y], 'Edges', {linspace(min(x), max(x), nbins+1), linspace(min(y), max(y), nbins+1)});
counts=counts*0.1;
% Heatmap
figure
imagesc(edges{1}, edges{2}, counts')
colormap(jet)  
colorbar 
caxis([min(counts(:)), max(counts(:))]);
axis xy 
xlim([300 1000])
ylim([200 800])
%xlabel('Pixel') 
%ylabel('Pixel')
set(gca, 'Color', [0, 0, 0.56]); 
hold on
rectangle('Position', [550, 370, 10, 20], 'EdgeColor', 'none', 'FaceColor', 'w');  % Rectangle at x = 500
rectangle('Position', [700, 370, 10, 20], 'EdgeColor', 'none', 'FaceColor', 'w');  % Rectangle at x = 500
hold off
