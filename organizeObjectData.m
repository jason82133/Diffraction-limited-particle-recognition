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
    xList = [];
    yList = [];

    % Loop through each image
    for i = 1:numImages
        objectData = objects{i};

        %folderList{i} = objectData{i}.folderName;
        %imageList{i} = objectData{i}.imageName;

        objectN = numel(objectData);

        tempPosListN = zeros(objectN,4);
        imagePosListN = cell(objectN,1);
        tempListN = zeros(objectN,10);
        folderListN = cell(objectN,1);
        imageListN = cell(objectN,1);
        wellListN = cell(objectN,1);
        xListN = cell(objectN,1);
        yListN = cell(objectN,1);
        
        % Loop through each object in the current image
        for j = 1:objectN

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

            tempPosListN(j,1) = j;
            tempPosListN(j,2) = CentroidPositionsX;
            tempPosListN(j,3) = CentroidPositionsY;
            tempPosListN(j,4) = i;

            imagePosListN{j} = {objectData{j}.imageName};

            tempListN(j, 1) = j;
            tempListN(j, 2) = sumIntensity;
            tempListN(j, 3) = avgPixelIntensity;
            tempListN(j, 4) = SB_diff;
            tempListN(j, 5) = numPixels;
            tempListN(j, 6) = Eccentricity;
            tempListN(j, 7) = Background;
            tempListN(j, 8) = ImageMean;
            tempListN(j, 9) = ImageStd;
            tempListN(j, 10) = i;

            folderListN{j} = {objectData{j}.folderName};
            imageListN{j} = {objectData{j}.imageName};
            wellListN{j} = {objectData{j}.wellName};
            xListN{j} = {objectData{j}.xName};
            yListN{j} = {objectData{j}.yName};

            % tempPosList = [tempPosList; j, CentroidPositionsX, CentroidPositionsY, i];
            % imagePosList = [imagePosList; {objectData{j}.imageName}];
            % 
            % % Append the properties in an image to the temp list
            % tempList = [tempList; j, sumIntensity, avgPixelIntensity, SB_diff, numPixels, Eccentricity, Background, ImageMean, ImageStd, i];
            % folderList = [folderList; {objectData{j}.folderName}];
            % imageList = [imageList; {objectData{j}.imageName}];
            % wellList = [wellList; {objectData{j}.wellName}];
            % xList = [xList; {objectData{j}.xName}];
            % yList = [yList; {objectData{j}.yName}];
        end

        % Append the properties in an image to the temp list
        tempPosList = [tempPosList; tempPosListN];
        imagePosList = [imagePosList; imagePosListN];
        tempList = [tempList; tempListN];
        folderList = [folderList; folderListN];
        imageList = [imageList; imageListN];
        wellList = [wellList; wellListN];
        xList = [xList; xListN];
        yList = [yList; yListN];

        clear objectData
 
        disp(['Finding ' num2str(round(i/numImages*100, 1)) ' %'])
    end



    % Append the properties to the organized list
    
    objectList = struct('objectIndex', {}, 'Intensity', {}, 'AvgPixelIntensity', {}, 'SB_diff', {}, 'NumOfPixels', {}, 'Eccentricity', {}, 'Background', {}, 'ImageMean', {}, 'ImageStd', {}, 'imageNum', {}, 'folderName', {}, 'imageName', {}, 'wellName', {}, 'X', {}, 'Y', {});
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
        [objectList.X] = xList{:};
        [objectList.Y] = yList{:};
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
