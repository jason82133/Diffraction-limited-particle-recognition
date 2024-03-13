
% Main_fileReorganisation
% Version 1.11
%
% Copyright (c) 2023, by Jason C Sang.



%% Setting
clear all

% Specify the folder path to search for Excel files which belong to one single slide
folder_1 = 'Analysis 2024-03-13_19-52-54';
folder_2 = 'Analysis 2024-03-13_20-08-29'; % Folder to replace the X-Y coordinates
savePath = 'H:\Work\Arabidopsis\20240313_Simpull_Syn_abeta_capture-detection_tau2';

% Add a column of the slide label
slide_Name = '20240311_A';


% Define the replacements in the second excel file (to correct the X Y position pabels). Go from large to small numbers.
oldValues = {'Y2','Y1','Y0'};
newValues = {'Y3','Y2','Y1'};


%%

% Define the file filter for Excel files
fileFilter = {'*Output_*.xlsx', '*Output_*.xls'};

if ~isempty(folder_1)
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
        x_data = cellstr(table_2.X);
        y_data = cellstr(table_2.Y);
        
        % Loop through each old value and perform replacement
        for i = 1:numel(oldValues)
            % Find indices of rows containing the old value
            imageNameIndices = contains(imageName_data, oldValues{i});
            wellNameIndices = contains(wellName_data, oldValues{i});
            if contains(oldValues{i}, 'X')
                xIndices = contains(x_data, erase(oldValues{i},'X'));
            else
                xIndices = [];
            end
            if contains(oldValues{i}, 'Y')
                yIndices = contains(y_data, erase(oldValues{i},'Y'));
            else
                yIndices = [];
            end
        
            % Replace the old value with the new value
            imageName_data(imageNameIndices) = strrep(imageName_data(imageNameIndices), oldValues{i}, newValues{i});
            wellName_data(imageNameIndices) = strrep(wellName_data(wellNameIndices), oldValues{i}, newValues{i});
            if ~isempty(xIndices)
                x_data(imageNameIndices) = strrep(x_data(xIndices), erase(oldValues{i},'X'), erase(newValues{i},'X'));
            end
            if ~isempty(yIndices)
                y_data(imageNameIndices) = strrep(y_data(yIndices), erase(oldValues{i},'Y'), erase(newValues{i},'Y'));
            end
        end
        
         % Update the table with the modified column
        table_2.imageName = imageName_data;
        table_2.wellName = wellName_data;
        table_2.X = x_data;
        table_2.Y = y_data;
    end
    
    % Join two tables
    joinedTable = vertcat(table_1, table_2);

else
    folderPath_2 = [savePath, '\', folder_2];
    
    bb = dir(fullfile(folderPath_2, '**', fileFilter{1}));
    
    allFiles(2) = bb(1);
    
    % Load the files
    table_2 = readtable([allFiles(2).folder, '\', allFiles(2).name]);
    
    
    if ~isempty(oldValues) == 1 || ~isempty(newValues) == 1
        % Convert the column to a cell array of strings
        imageName_data = cellstr(table_2.imageName);
        wellName_data = cellstr(table_2.wellName);
        x_data = cellstr(table_2.X);
        y_data = cellstr(table_2.Y);
        
        % Loop through each old value and perform replacement
        for i = 1:numel(oldValues)
            % Find indices of rows containing the old value
            imageNameIndices = contains(imageName_data, oldValues{i});
            wellNameIndices = contains(wellName_data, oldValues{i});
            if contains(oldValues{i}, 'X')
                xIndices = contains(x_data, erase(oldValues{i},'X'));
            else
                xIndices = [];
            end
            if contains(oldValues{i}, 'Y')
                yIndices = contains(y_data, erase(oldValues{i},'Y'));
            else
                yIndices = [];
            end
        
            % Replace the old value with the new value
            imageName_data(imageNameIndices) = strrep(imageName_data(imageNameIndices), oldValues{i}, newValues{i});
            wellName_data(imageNameIndices) = strrep(wellName_data(wellNameIndices), oldValues{i}, newValues{i});
            if ~isempty(xIndices)
                x_data(imageNameIndices) = strrep(x_data(xIndices), erase(oldValues{i},'X'), erase(newValues{i},'X'));
            end
            if ~isempty(yIndices)
                y_data(imageNameIndices) = strrep(y_data(yIndices), erase(oldValues{i},'Y'), erase(newValues{i},'Y'));
            end
        end
        
         % Update the table with the modified column
        table_2.imageName = imageName_data;
        table_2.wellName = wellName_data;
        table_2.X = x_data;
        table_2.Y = y_data;
    end
    
    % Join two tables
    joinedTable = table_2;
end

outputTable = movevars(joinedTable, 'imageNum', 'Before', 'objectIndex');
outputTable = movevars(outputTable, 'imageName', 'Before', 'imageNum');
outputTable = movevars(outputTable, 'wellName', 'Before', 'imageName');
outputTable = movevars(outputTable, 'folderName', 'Before', 'wellName');

slideName = repmat({slide_Name}, size(outputTable,1), 1);
outputTable = addvars(outputTable, slideName, 'Before', 1);




%% Click and select

%global selectedWell;
%selectedWell = selectSlide;


% excelPath = 'C:\Users\jason\OneDrive\Desktop\Experimental plans\20240307 Assay experimental plan.xlsx';
% 
% % Read data from Excel
% excelTable = readtable(excelPath);
% 
% % Extract x, y, and color data from the table
% xData = excelTable.X;
% yData = excelTable.Y;
% colors = excelTable.Color;
% 
% % Create a scatter plot with colored points
% scatter(xData, yData, 50, colors, 'filled');
% colormap('jet'); % You can use a different colormap if needed
% 
% % Add labels and title
% xlabel('X Position');
% ylabel('Y Position');
% title('Scatter Plot with Colored Points');



%%
% Write the table to an Excel file
writetable(outputTable, [savePath '\Output_' slide_Name '.xlsx']);

disp('Data saved');