function [filteredList, filteredPosList, areaThreshold] = filterData(objectList, posList)
    % Filter rows in a structure based on criteria
    areaThreshold = [2, 300];

    % Initialize the filtered structure
    filteredList = objectList;
    filteredPosList = posList;
    % filteredList = struct('objectIndex', {}, 'Intensity', {}, 'AvgPixelIntensity', {}, 'SB_diff', {}, 'NumOfPixels', {}, 'Eccentricity', {}, 'Background', {}, 'ImageMean', {}, 'ImageStd', {}, 'imageNum', {}, 'folderName', {}, 'imageName', {}, 'wellName', {}, 'X', {}, 'Y', {});
    % filteredPosList = struct('objectIndex', {}, 'CentroidPosX', {}, 'CentroidPosY', {}, 'imageNum', {}, 'imageName', {});

    % Iterate through each entry in the original structure
    ind = [];

    for i = 1:numel(filteredList)
        % Extract relevant fields
        %eccentricity = originalStruct(i).Eccentricity;
        numOfPixels = filteredList(i).NumOfPixels;

        % Check the criteria
        if numOfPixels <= areaThreshold(1) || numOfPixels >= areaThreshold(2)
            ind(end + 1) = i;
        end
    end

        filteredList(ind) = [];
        filteredPosList(ind) = [];

        % if numOfPixels > areaThreshold(1) && numOfPixels < areaThreshold(2)
        %     % Add the entry to the filtered structurec
        %     filteredList(i) = [];
        %     filteredPosList(i) = [];
        %     % filteredList(end + 1) = objectList(i);
        %     % filteredPosList(end + 1) = posList(i);
        % end
    
    if ~isempty(filteredList) == 1
        temp = flaggingMech(filteredList);
    end


    % Add a new field 'Flags' and flag the filtered elements
    parfor rowFilteredList = 1:numel(filteredList)
        filteredList(rowFilteredList).Flags = temp{rowFilteredList};  % Label filtered elements
    end

end
