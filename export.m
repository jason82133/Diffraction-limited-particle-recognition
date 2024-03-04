function savePath = export(file, filePath, folderName, smoothSize, areaThreshold, pThreshold)
    %% Results    
    % Convert the structure to a table
    dataTable = struct2table(file);

    % Get the current date and time
    currentDateTime = datetime('now', 'Format', 'yyyy-MM-dd_HH-mm-ss');
    timestampString = char(currentDateTime);

    savePath = [filePath, '\Analysis ', timestampString];
    mkdir(savePath);
    
    % Write the table to an Excel file
    writetable(dataTable, [savePath '\Output_' folderName '.xlsx']);

    %% Log
    % Open the file for writing
    logFile = fopen([savePath '\Log.txt'], 'w');
    
    % Check if the file is successfully opened
    if logFile == -1
        error('Error: Unable to open the file for writing.');
    end
    
    % Write the variables to the file
    fprintf(logFile, 'Threshold for intensity histogram above percentage: %f\n', pThreshold);
    fprintf(logFile, 'Smoothing of n-sized pixels for top-hat and median filtering: %d\n', smoothSize);
    fprintf(logFile, 'Exclude particles between n pixels: %d, %d', areaThreshold);
    
    % Close the file
    fclose(logFile);
    
    disp('Files saved');
end