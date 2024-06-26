function [filteredList, filteredPosList, areaThreshold] = filterData(objectList, posList)
    % Filter rows in a structure based on criteria

    % Initialize the filtered structure
    filteredList = struct('objectIndex', {}, 'Intensity', {}, 'AvgPixelIntensity', {}, 'SB_diff', {}, 'NumOfPixels', {}, 'Eccentricity', {}, 'Background', {}, 'ImageMean', {}, 'ImageStd', {}, 'imageNum', {}, 'folderName', {}, 'imageName', {}, 'wellName', {}, 'X', {}, 'Y', {});
    filteredPosList = struct('objectIndex', {}, 'CentroidPosX', {}, 'CentroidPosY', {}, 'imageNum', {}, 'imageName', {});

    % Iterate through each entry in the original structure
    for i = 1:numel(objectList)
        % Extract relevant fields
        %eccentricity = originalStruct(i).Eccentricity;
        numOfPixels = objectList(i).NumOfPixels;

        % Check the criteria
        areaThreshold = [2, 300];

        if numOfPixels > areaThreshold(1) && numOfPixels < areaThreshold(2)
            % Add the entry to the filtered structurec
            filteredList(end + 1) = objectList(i);
            filteredPosList(end + 1) = posList(i);
        end
    end
    
    if ~isempty(filteredList) == 1
        temp = flaggingMech(filteredList);
    end

    % Add a new field 'Flags' and flag the filtered elements
    for rowFilteredList = 1:numel(filteredList)
        filteredList(rowFilteredList).Flags = temp{rowFilteredList};  % Label filtered elements
    end

end
