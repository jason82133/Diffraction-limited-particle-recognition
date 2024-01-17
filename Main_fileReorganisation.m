% Copyright (c) 2023, by Jason C Sang.

%% Setting
clear all

% Specify the folder path to search for Excel files which belong to one single slide
folder_1 = 'Analysis 2024-01-17_22-14-09';
folder_2 = 'Analysis 2024-01-17_22-18-39';
savePath = 'G:\Arabidopsis\20240115_Simpull_Syn_Serum dilution\Analysis smoothSize = 3, CV=20%, floating fitting pValue_modified';

% Add a column of the slide label
slide_Name = '20240115-Q';


% Define the replacements in the second excel file (to correct the X Y position pabels). Go from large to small numbers.
oldValues = {'Y2', 'Y1', 'Y0'};
newValues = {'Y3', 'Y2', 'Y1'};


%%

% Define the file filter for Excel files
fileFilter = {'*Output_*.xlsx', '*Output_*.xls'};

% Get a list of all files in the specified path and its subfolders
folderPath_1 = [savePath, '\', folder_1];
folderPath_2 = [savePath, '\', folder_2];

aa = dir(fullfile(folderPath_1, '**', fileFilter{1}));
bb = dir(fullfile(folderPath_2, '**', fileFilter{1}));

allFiles(1) = aa(1);
allFiles(2) = bb(1);

% Load the files
table_1 = readtable([allFiles(1).folder, '\', allFiles(1).name]);
table_2 = readtable([allFiles(2).folder, '\', allFiles(2).name]);


if ~isempty(oldValues) == 1 || ~isempty(newValues) == 1
    % Convert the column to a cell array of strings
    imageName_data = cellstr(table_2.imageName);
    wellName_data = cellstr(table_2.wellName);
    
    % Loop through each old value and perform replacement
    for i = 1:numel(oldValues)
        % Find indices of rows containing the old value
        imageNameIndices = contains(imageName_data, oldValues{i});
        wellNameIndices = contains(wellName_data, oldValues{i});
    
        % Replace the old value with the new value
        imageName_data(imageNameIndices) = strrep(imageName_data(imageNameIndices), oldValues{i}, newValues{i});
        wellName_data(imageNameIndices) = strrep(wellName_data(wellNameIndices), oldValues{i}, newValues{i});
    end
    
     % Update the table with the modified column
    table_2.imageName = imageName_data;
    table_2.wellName = wellName_data;
end

% Join two tables
joinedTable = vertcat(table_1, table_2);


outputTable = movevars(joinedTable, 'imageNum', 'Before', 'objectIndex');
outputTable = movevars(outputTable, 'imageName', 'Before', 'imageNum');
outputTable = movevars(outputTable, 'wellName', 'Before', 'imageName');
outputTable = movevars(outputTable, 'folderName', 'Before', 'wellName');

slideName = repmat({slide_Name}, size(outputTable,1), 1);
outputTable = addvars(outputTable, slideName, 'Before', 1);


%%
% global selectedWell;
% selectedWell = [];
% 
% % Create a figure
% f = figure('Name', 'Selectable Grid', 'Position', [100, 100, 500, 240]);
% 
% % Create a grid with x and y positions
% x = 0:9;
% y = 0:3;
% 
% % Set the callback function for button clicks
% buttonCallback = @(src, event) buttonClicked(src, event, x, y);
% 
% % Create buttons for each position in the grid
% for i = 1:numel(x)
%     for j = 1:numel(y)
%         % Calculate button position
%         xPos = x(i);
%         yPos = y(j);
% 
%         % Create button
%         %uipanel(f,'Position',[0.1 0.1 0.35 0.65]);
%         pushbutton = uicontrol('Style', 'pushbutton', 'String', '' , 'Position', [380-xPos*40, 140-yPos*40, 40, 40], ...
%             'Callback', buttonCallback, 'UserData', [xPos, yPos], 'BackgroundColor', [1, 1, 1]);
% 
%     end
% end
% 
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.76,0.75,0.075,0.075], 'String', '0', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.68,0.75,0.075,0.075], 'String', '1', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.60,0.75,0.075,0.075], 'String', '2', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.52,0.75,0.075,0.075], 'String', '3', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.44,0.75,0.075,0.075], 'String', '4', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.36,0.75,0.075,0.075], 'String', '5', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.28,0.75,0.075,0.075], 'String', '6', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.20,0.75,0.075,0.075], 'String', '7', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.12,0.75,0.075,0.075], 'String', '8', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.04,0.75,0.075,0.075], 'String', '9', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.84,0.62,0.075,0.075], 'String', '0', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.84,0.45,0.075,0.075], 'String', '1', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.84,0.28,0.075,0.075], 'String', '2', 'FontSize', 10);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.84,0.12,0.075,0.075], 'String', '3', 'FontSize', 10);
% 
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.40,0.88,0.075,0.075], 'String', 'X', 'FontSize', 12.5);
% uicontrol('style', 'text', 'unit', 'normalized', 'position', [0.90,0.36,0.075,0.075], 'String', 'Y', 'FontSize', 12.5);


%%
% Write the table to an Excel file
writetable(outputTable, [savePath '\Output_' slide_Name '.xlsx']);

disp('Data saved');