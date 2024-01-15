function [filteredList, filteredPosList] = filterData(originalStruct, posList)
    % Filter rows in a structure based on criteria (Eccentricity >= 0.2, numOfPixels > 10, and numOfPixels < 100)

    % Initialize the filtered structure
    filteredList = struct('objectIndex', {}, 'Intensity', {}, 'AvgPixelIntensity', {}, 'SB_diff', {}, 'NumOfPixels', {}, 'Eccentricity', {}, 'BackgroundMean', {}, 'BackgroundStd', {}, 'imageNum', {}, 'folderName', {}, 'imageName', {}, 'wellName', {});
    filteredPosList = struct('objectIndex', {}, 'CentroidPosX', {}, 'CentroidPosY', {}, 'imageNum', {}, 'imageName', {});

    % Iterate through each entry in the original structure
    for i = 1:numel(originalStruct)
        % Extract relevant fields
        %eccentricity = originalStruct(i).Eccentricity;
        numOfPixels = originalStruct(i).NumOfPixels;

        % Check the criteria
        %if eccentricity >= 0.3 && numOfPixels > 2 && numOfPixels < 100
        if numOfPixels > 3 && numOfPixels < 200
            % Add the entry to the filtered structurec
            filteredList(end + 1) = originalStruct(i);
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
