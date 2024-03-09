function [objectList, posList] = organizeObjectData(objects)
    % Reorganize the processedObjects data into a new list

    numImages = numel(objects);

    % Initialize the organized list
    tempPosList = [];
    imagePosList = [];
    tempList = [];
    folderList = [];
    imageList = [];
    wellList = [];

    % Loop through each image
    for i = 1:numImages
        objectData = objects{i};

        %folderList{i} = objectData{i}.folderName;
        %imageList{i} = objectData{i}.imageName;

        % Loop through each object in the current image
        for j = 1:numel(objectData)
            % Extract properties for the current object
            sumIntensity = objectData{j}.SumIntensity;
            avgPixelIntensity = objectData{j}.avgPixelIntensity;
            SB_diff = objectData{j}.SBdiff;
            numPixels = objectData{j}.NumPixels;
            Eccentricity = objectData{j}.Eccentricity;
            Background = objectData{j}.Background;
            ImageMean = objectData{j}.MeanOfImage;
            ImageStd = objectData{j}.StDOfImage;
            CentroidPositionsX = objectData{j}.CentroidPositions(1);
            CentroidPositionsY = objectData{j}.CentroidPositions(2);
            

            % Loop through each pixel in the current object
            % for k = 1:numel(objectData{j}.PixelPositions(:,1))
            %     posX = objectData{j}.PixelPositions(k,2);
            %     posY = objectData{j}.PixelPositions(k,1);
            % 
            %     tempPosList = [tempPosList; j, posX, posY, CentroidPositionsX, CentroidPositionsY, i];
            %     imagePosList = [imagePosList; {objectData{j}.imageName}];
            % end
            tempPosList = [tempPosList; j, CentroidPositionsX, CentroidPositionsY, i];
            imagePosList = [imagePosList; {objectData{j}.imageName}];

            % Append the properties in an image to the temp list
            tempList = [tempList; j, sumIntensity, avgPixelIntensity, SB_diff, numPixels, Eccentricity, Background, ImageMean, ImageStd, i];
            folderList = [folderList; {objectData{j}.folderName}];
            imageList = [imageList; {objectData{j}.imageName}];
            wellList = [wellList; {objectData{j}.wellName}];
        end
        clear objectData

        disp([num2str(round(i/numImages*100, 1)) ' %'])
    end

    % Append the properties to the organized list
    
    objectList = struct('objectIndex', {}, 'Intensity', {}, 'AvgPixelIntensity', {}, 'SB_diff', {}, 'NumOfPixels', {}, 'Eccentricity', {}, 'Background', {}, 'ImageMean', {}, 'ImageStd', {}, 'imageNum', {}, 'folderName', {}, 'imageName', {}, 'wellName', {});
    objectList = repmat(objectList, length(tempList), 1);
    for num = 1:length(tempList)
       objectList(num).objectIndex = tempList(num,1);
       objectList(num).Intensity = tempList(num,2);
       objectList(num).AvgPixelIntensity = tempList(num,3);
       objectList(num).SB_diff = tempList(num,4);
       objectList(num).NumOfPixels = tempList(num,5);
       objectList(num).Eccentricity = tempList(num,6);
       objectList(num).Background = tempList(num,7);
       objectList(num).ImageMean = tempList(num,8);
       objectList(num).ImageStd = tempList(num,9);
       objectList(num).imageNum = tempList(num,10);
    end
    if ~isempty(objectList) == 1
        [objectList.folderName] = folderList{:};
        [objectList.imageName] = imageList{:};
        [objectList.wellName] = wellList{:};
    end
    
    posList = struct('objectIndex', {}, 'CentroidPosX', {}, 'CentroidPosY', {}, 'imageNum', {}, 'imageName', {});
    posList = repmat(posList, length(tempPosList), 1);
    for numPos = 1:length(tempPosList)
        posList(numPos).objectIndex = tempPosList(numPos,1);
        posList(numPos).CentroidPosX = tempPosList(numPos,2);
        posList(numPos).CentroidPosY = tempPosList(numPos,3);
        posList(numPos).imageNum = tempPosList(numPos,4);
    end
    
    if ~isempty(objectList) == 1
        [posList.imageName] = imagePosList{:};
    end
end
