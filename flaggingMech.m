function flaggedList = flaggingMech(filteredList)

    Data_wellName = {filteredList.wellName};
    Data_imageName = {filteredList.imageName};

    % Use unique to get unique elements and their counts
    uniqueWell = unique(Data_wellName);
    [uniqueImage, firstImagePos, ~] = unique(Data_imageName);
    
    flaggedList = cell(size(Data_imageName,2), 1);
    
    for tempNum = 1:size((flaggedList),1)
        flaggedList{tempNum} = 'None';
    end



    %% Intra-well flagging for ImageMean outliers
    for wellNum = 1:numel(uniqueWell)

        wellPos = find(ismember(firstImagePos, find(ismember(Data_wellName, uniqueWell{wellNum})))); % select the well and the specified well name
        
        clear data_ImageMean

        for j = 1:numel(wellPos)
            data_ImageMean(j) = filteredList(firstImagePos(wellPos(j))).ImageMean;
        end 

        % mean_b = mean(data_ImageMean);
        % std_b = std(data_ImageMean);
        % 
        % % Define the range for threshold is +-10% of the mean
        % level = 0.1;
        % 
        % % Calculate the threshold for filtering
        % thresholdHigh = mean_b*(1 + level);
        % thresholdLow = mean_b*(1 - level);
        % 
        % % Identify elements with p-value > 2 sigma
        % filteredIndices_ImageMean = find(data_ImageMean > thresholdHigh | data_ImageMean < thresholdLow);

        % Identify outliers as elements more than three scaled MAD from the median
        outlierList_ImageMean = find(isoutlier(data_ImageMean));
        outlierPosList_ImageMean = wellPos(outlierList_ImageMean);
        
        if ~isempty(outlierPosList_ImageMean) == 1
            for i = 1:numel(outlierPosList_ImageMean)
                % filteredPos{i} = find(ismember(Data_imageName, uniqueImage{filteredIndices_ImageMean(i)}));
                filteredPos{i} = find(ismember(Data_imageName, uniqueImage{outlierPosList_ImageMean(i)}));
            end
        else
            filteredPos = [];
        end
        
        % Flagging identified images
        if ~isempty(filteredPos) == 1
            for filteredNum_b = 1:numel(filteredPos)
                for k = 1: numel(filteredPos{filteredNum_b})
                    flaggedList{filteredPos{filteredNum_b}(k)} = 'ImageMean outlier';
                end
            end
        end
    end


end