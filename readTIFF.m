function [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName, xName, yName] = readTIFF(folderPath, truncatedFrame)

    % Get a list of all TIFF files in the folder
    tifFiles = dir(fullfile(folderPath, '*.tif'));
    imageName = cell(size(tifFiles));

    % Get the folder name of selection
    [~, folderName, ~] = fileparts(folderPath);
    
    % Extract the part of the file name from 'X' to 'Y' using regular expressions
    pattern = 'X(\d+)Y(\d+)'; % Match 'X' followed by digits, then 'Y' followed by digits

    % Get the image name
    % Use the pattern to get the well number part
    for k = 1:numel(tifFiles)
        parts = strsplit(tifFiles(k).name, '_');
        imageName{k} = parts{1};

        matchedWell = regexp(tifFiles(k).name, pattern, 'tokens', 'once');
        wellName{k} = ['X' matchedWell{1} 'Y' matchedWell{2}];
        xName{k} = matchedWell{1};
        yName{k} = matchedWell{2};
    end
    
    % Initialize a cell array to store the image stack and corresponding file names
    averagedStacksList = cell(1, numel(tifFiles));
    averagedFileNamesList = cell(1, numel(tifFiles));
    %processedImagesList = cell(1, numel(tifFiles));
    
    % Read each TIFF file and store it in the cell array along with the file name
    for i = 1:numel(tifFiles)
    
        % Construct the full path to the current TIFF file
        filePath = fullfile(folderPath, tifFiles(i).name);
        
        % Read only the header of the example file to get information
        info = imfinfo(filePath);
        
        % Remove frames after the specified number
        if isempty(truncatedFrame) == 1
            frameLoaded = numel(info);
        else
            frameLoaded = truncatedFrame;
        end

        % Read the TIFF image
        for j = 1:frameLoaded
            currentImage(:,:,j) = imread(filePath, j);
        end
        
    
        % Average the image stacks
        [averagedStacks, averagedFileNames] = stackAverage(currentImage, tifFiles(i).name);
    
        averagedStacksList{i} = averagedStacks;
        averagedFileNamesList{i} = averagedFileNames;
    
    end

end