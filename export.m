function savePath = export(file, filePath, folderName)
    % Convert the structure to a table
    dataTable = struct2table(file);

    % Get the current date and time
    currentDateTime = datetime('now', 'Format', 'yyyy-MM-dd_HH-mm-ss');
    timestampString = char(currentDateTime);

    savePath = [filePath, '\Analysis ', timestampString];
    mkdir(savePath);
    
    % Write the table to an Excel file
    writetable(dataTable, [savePath '\Output_' folderName '.xlsx']);
end