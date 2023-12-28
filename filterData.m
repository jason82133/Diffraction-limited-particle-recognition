function filteredList = filterData(originalStruct)
    % Filter rows in a structure based on criteria (Eccentricity >= 0.2, numOfPixels > 10, and numOfPixels < 100)

    % Initialize the filtered structure
    filteredList = struct('objectIndex', {}, 'Intensity', {}, 'AvgPixelIntensity', {}, 'SB_diff', {}, 'NumOfPixels', {}, 'Eccentricity', {}, 'BackgroundMean', {}, 'BackgroundStd', {}, 'imageNum', {}, 'folderName', {}, 'imageName', {}, 'wellName', {});

    % Iterate through each entry in the original structure
    for i = 1:numel(originalStruct)
        % Extract relevant fields
        %eccentricity = originalStruct(i).Eccentricity;
        numOfPixels = originalStruct(i).NumOfPixels;

        % Check the criteria
        %if eccentricity >= 0.3 && numOfPixels > 2 && numOfPixels < 100
        if numOfPixels > 2 && numOfPixels < 200
            % Add the entry to the filtered structurec
            filteredList(end + 1) = originalStruct(i);
        end
    end

end
