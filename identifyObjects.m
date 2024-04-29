function objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma, bg, xName, yName)

    disp('Finding aggregates..')

    % Process a series of images, identify objects, and calculate object properties
    numImages = numel(outputImageList);
    objects = cell(1, numImages);

    parfor i = 1:numImages
        currentImage = outputImageList{i};

        % Identify connected components (objects) in the binary image
        binaryImage = currentImage > 0;  % Assuming background pixels are already removed
        labeledImage = bwlabel(binaryImage);
        
        % Remove objects at edge
        labeledImage = imclearborder(labeledImage);
        
        % Fill holes in objects
        labeledImage = imfill(labeledImage,"holes");

        % Measure properties of connected components
        stats = regionprops(labeledImage, 'PixelIdxList', 'Centroid', 'Area', 'Eccentricity', 'BoundingBox');

        % Extract information for each object
        numObjects = numel(stats);
        objectData = cell(1, numObjects);

        for j = 1:numObjects
            % Identify each pixel's position
            [row, col] = ind2sub(size(currentImage), stats(j).PixelIdxList);

            % Calculate sum intensity
            sumIntensity = sum(currentImage(stats(j).PixelIdxList));
            
            % Calculate number of pixels of an object
            NumPixels = numel(row);
           
            % Store object data
            objectData{j}.folderName = folderName;
            objectData{j}.imageName = imageName{i};
            objectData{j}.wellName = wellName{i};
            objectData{j}.xName = xName{i};
            objectData{j}.yName = yName{i};
            objectData{j}.PixelPositions = [row, col];
            objectData{j}.CentroidPositions = stats(j).Centroid;
            objectData{j}.NumPixels = NumPixels;
            objectData{j}.SumIntensity = sumIntensity;
            objectData{j}.avgPixelIntensity = sumIntensity/NumPixels;
            objectData{j}.SBdiff = sumIntensity - NumPixels*bg(i);
            objectData{j}.AvgIntdiff = sumIntensity/NumPixels - bg(i);
            objectData{j}.Eccentricity = stats(j).Eccentricity;
            objectData{j}.Background = bg(i);
            objectData{j}.MeanOfImage = mu(i);
            objectData{j}.StDOfImage = sigma(i);
        end

        % Store object data for the current image
        objects{i} = objectData;
    end
end
