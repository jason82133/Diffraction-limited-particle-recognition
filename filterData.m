function [filteredList, filteredPosList, areaThreshold] = filterData(objectList, posList)

    disp('Filtering..')

    % Filter rows in a structure based on criteria
    areaThreshold = [2, 300];

    % Initialize the filtered structure
    filteredList = objectList;
    filteredPosList = posList;

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

    
    % Add a new field 'Flags' and flag the filtered elements
    if ~isempty(filteredList) == 1
        temp = flaggingMech(filteredList);
    end

    parfor rowFilteredList = 1:numel(filteredList)
        filteredList(rowFilteredList).Flags = temp{rowFilteredList};  % Label filtered elements
    end

end
