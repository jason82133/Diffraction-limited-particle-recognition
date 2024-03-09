function temp = flaggingMech(filteredList)

    Data_wellName = {filteredList.wellName};
    Data_imageName = {filteredList.imageName};

    % Use unique to get unique elements and their counts
    uniqueWell = unique(Data_wellName);
    [uniqueImage, firstImagePos, ~] = unique(Data_imageName);
    
    % Subject to calculations
    for wellNum = 1:numel(uniqueWell)

        wellPos = find(ismember(find(ismember(Data_wellName, uniqueWell{wellNum})), firstImagePos)); % select the well that has objectOndex of 1 and the specified well name

        for j = 1:numel(wellPos)
            data_ImageMean(j) = filteredList(wellPos(j)).ImageMean;
        end 

        mean_b = mean(data_ImageMean);
        std_b = std(data_ImageMean);
        
        % Define the range for threshold is +-10% of the mean
        level = 0.1;
        
        % Calculate the threshold for filtering
        highThreshold = mean_b*(1 + level);
        lowThreshold = mean_b*(1 - level);
        
        % Identify elements with p-value > 2 sigma
        filteredIndices_ImageMean = find(data_ImageMean > highThreshold | data_ImageMean < lowThreshold);
        
        if ~isempty(filteredIndices_ImageMean) == 1
            for i = 1:numel(filteredIndices_ImageMean)
                filteredPos{i} = find(ismember(Data_imageName, uniqueImage{filteredIndices_ImageMean(i)}));
            end
        else
            filteredPos = [];
        end

        temp = cell(size(Data_imageName,2), 1);
        
        for tempNum = 1:size((temp),1)
            temp{tempNum} = 'None';
        end

        if ~isempty(filteredPos) == 1
            for filteredNum_b = 1:numel(filteredPos)
                for k = 1: numel(filteredPos{filteredNum_b})
                    temp{filteredPos{filteredNum_b}(k)} = 'b';
                end
            end
        end
    end
end