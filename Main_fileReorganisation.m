
% Main_fileReorganisation
% Version 1.12.4
%
% Copyright (c) 2023, by Jason C Sang.



%% Setting
clearvars

% Specify the folder path to search for Excel files which belong to one single slide
folder_1 = 'Analysis 2024-05-17_15-46-00';
folder_2 = 'Analysis 2024-05-17_16-21-03'; % Folder to replace the X-Y coordinates
savePath = 'H:\Artemisia\20240513_Simpull_Syn_abeta_serum sample storage batch 2';

% Add a column of the slide label
slide_Name = '20240513_211';


% Define the replacements in the second excel file (to correct the X Y position pabels). Go from large to small numbers.
oldValues = {'X5','X4','X3','X2','X1','X0'};
newValues = {'X9','X8','X7','X6','X5','X4'};


%%

% Define the file filter for Excel files
fileFilter = {'*Output_*.csv'};

if ~isempty(folder_1)
    % Get a list of all files in the specified path and its subfolders
    folderPath_1 = [savePath, '\', folder_1];
    folderPath_2 = [savePath, '\', folder_2];
    
    aa = dir(fullfile(folderPath_1, '**', fileFilter{1}));
    bb = dir(fullfile(folderPath_2, '**', fileFilter{1}));

    numberTable_a = numel(aa);
    numberTable_b = numel(bb);

    if numberTable_a == 1
        allFiles_a(1) = aa(1);
    else
        for j = 1:numberTable_a
           allFiles_a(j) = aa(j);
        end
    end
    if numberTable_b == 1
        allFiles_b(1) = bb(1);
    else
        for j = 1:numberTable_b
           allFiles_b(j) = bb(j);
        end
    end

    
    % Load the files
    disp('Loading..(1/3)')
    if numberTable_a == 1
        table_1 = readtable([allFiles_a(1).folder, '\', allFiles_a(1).name], "Delimiter", "comma");
    else
        table_1 = readtable([allFiles_a(1).folder, '\', allFiles_a(1).name], "Delimiter", "comma");
        for j = 2:numberTable_a
            clear tableTemp
            tableTemp_1 = readtable([allFiles_a(j).folder, '\', allFiles_a(j).name]);
            table_1 = [table_1; tableTemp_1];
        end
    end

    if numberTable_b == 1
        table_2 = readtable([allFiles_b(1).folder, '\', allFiles_b(1).name], "Delimiter", "comma");
    else
        table_2 = readtable([allFiles_b(1).folder, '\', allFiles_b(1).name], "Delimiter", "comma");
        for j = 2:numberTable_b
            clear tableTemp
            tableTemp_2 = readtable([allFiles_b(j).folder, '\', allFiles_b(j).name]);
            table_2 = [table_2; tableTemp_2];
        end
    end
    
    disp('Converting..(2/3)')
    if ~isempty(oldValues) == 1 || ~isempty(newValues) == 1
        % Convert the column to a cell array of strings
        imageName_data = cellstr(table_2.imageName);
        wellName_data = cellstr(table_2.wellName);
        x_data = cellstr(num2str(table_2.X));
        y_data = cellstr(num2str(table_2.Y));
        
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
        
        table_1.X = cellstr(num2str(table_1.X));
        table_1.Y = cellstr(num2str(table_1.Y));
    end
    
    % Join two tables
    joinedTable = vertcat(table_1, table_2);

else
    folderPath_2 = [savePath, '\', folder_2];
    
    bb = dir(fullfile(folderPath_2, '**', fileFilter{1}));
    
    numberTable = numel(bb);

    if numberTable == 1
        allFiles(1) = bb(1);
    else
        for j = 1:numberTable
           allFiles(j) = bb(j);
        end
    end
    
    % Load the files
    disp('Loading..(1/3)')

    if numberTable == 1
        table_2 = readtable([allFiles(1).folder, '\', allFiles(1).name], "Delimiter", "comma");
    else
        table_2 = readtable([allFiles(1).folder, '\', allFiles(1).name], "Delimiter", "comma");
        for j = 2:numberTable
            clear tableTemp
            tableTemp = readtable([allFiles(j).folder, '\', allFiles(j).name]);
            table_2 = [table_2; tableTemp];
        end
    end

    disp('Converting..(2/3)')
    if ~isempty(oldValues) == 1 || ~isempty(newValues) == 1
        % Convert the column to a cell array of strings
        imageName_data = cellstr(table_2.imageName);
        wellName_data = cellstr(table_2.wellName);
        x_data = cellstr(num2str(table_2.X));
        y_data = cellstr(num2str(table_2.Y));
        
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
disp('Saving data..(3/3)');

sizeTable = size(outputTable,1);

if sizeTable < 2^20
    writetable(outputTable, [savePath '\Output_' slide_Name '.csv']);
else
    if rem(sizeTable,2) == 1
        writetable(outputTable(1:(sizeTable-1)/2, :), [savePath '\Output_' slide_Name '_1.csv']);
        writetable(outputTable(((sizeTable-1)/2+1):sizeTable, :), [savePath '\Output_' slide_Name '_2.csv']);
    else
        writetable(outputTable(1:sizeTable/2, :), [savePath '\Output_' slide_Name '_1.csv']);
        writetable(outputTable((sizeTable/2+1):sizeTable, :), [savePath '\Output_' slide_Name '_2.csv']);
    end
end

disp('Completed');