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
            data_BackgroundMean(j) = filteredList(wellPos(j)).BackgroundMean;
        end 

        mean_b = mean(data_BackgroundMean);
        std_b = std(data_BackgroundMean);
        
        % Define the significance level of sigma for flagging unusual elements in a well
        significanceLevel = 2;
        
        % Calculate the threshold for filtering
        highThreshold = mean_b + significanceLevel * std_b;
        lowThreshold = mean_b - significanceLevel * std_b;
        
        % Identify elements with p-value > 2 sigma
        filteredIndices_BackgroundMean = find(data_BackgroundMean > highThreshold | data_BackgroundMean < lowThreshold);
        
        if ~isempty(filteredIndices_BackgroundMean) == 1
            filteredPos = find(ismember(Data_imageName, uniqueImage{filteredIndices_BackgroundMean}));
        else
            filteredPos = [];
        end

        temp = cell(size(Data_imageName,2), 1);
        
        for tempNum = 1:size((temp),1)
            temp{tempNum} = 'None';
        end

        if ~isempty(filteredPos) == 1
            for filteredNum_b = 1:numel(filteredPos)
                temp{filteredPos(filteredNum_b)} = 'b';
            end
        end
    end
end