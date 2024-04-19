function savePath = export(file, filePath, folderName, areaThreshold, smoothSize)
    %% Results    
    % Convert the structure to a table
    dataTable = struct2table(file);

    % Get the current date and time
    currentDateTime = datetime('now', 'Format', 'yyyy-MM-dd_HH-mm-ss');
    timestampString = char(currentDateTime);

    savePath = [filePath, '\Analysis ', timestampString];
    mkdir(savePath);
    
    % Write the table to an Excel file
    sizeTable = size(dataTable,1);

    if sizeTable < 2^20
        writetable(dataTable, [savePath '\Output_' folderName '.xlsx']);
    else
        if rem(sizeTable,2) == 1
            writetable(dataTable(1:(sizeTable-1)/2, :), [savePath '\Output_' folderName '_1.xlsx']);
            writetable(dataTable(((sizeTable-1)/2+1):sizeTable, :), [savePath '\Output_' folderName '_2.xlsx']);
        else
            writetable(dataTable(1:sizeTable/2, :), [savePath '\Output_' folderName '_1.xlsx']);
            writetable(dataTable((sizeTable/2+1):sizeTable, :), [savePath '\Output_' folderName '_2.xlsx']);
        end
    end

    %% Log
    % Open the file for writing
    logFile = fopen([savePath '\Log.txt'], 'w');
    
    % Check if the file is successfully opened
    if logFile == -1
        error('Error: Unable to open the file for writing.');
    end
    
    % Write the variables to the file
    %fprintf(logFile, 'Threshold for intensity histogram above percentage: %f\n', pThreshold);
    fprintf(logFile, 'Smoothing of n-sized pixels for top-hat and median filtering: %d\n', smoothSize);
    fprintf(logFile, 'Exclude particles between n pixels: %d\n', areaThreshold);
    
    % Close the file
    fclose(logFile);
    
    disp('Files saved');
end