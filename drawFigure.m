function drawFigure(averagedStacksList, filteredPosList, dataPath, imageName)
    
    warning('off','MATLAB:MKDIR:DirectoryExists')
    figPath = [dataPath '\Figures'];
    mkdir(figPath);
    
    uniqueImageNum = unique([filteredPosList.imageNum]);

    imageList = [filteredPosList.imageNum];

    lengthList = numel(uniqueImageNum);
    
    for imageNum = 1:lengthList
        clear currentImage

        % Display the original and processed images for comparison
        currentImage = averagedStacksList{imageNum};
        %aggregateImage = zeros(size(currentImage));
        aggregateImage = currentImage;
                
        aggregateListOftheImage = struct('objectIndex', {}, 'CentroidPosX', {}, 'CentroidPosY', {}, 'imageNum', {}, 'imageName', {});
        
        ind = imageList == uniqueImageNum(imageNum);
        aggregateListOftheImage = filteredPosList(ind);
        
        if isempty(aggregateListOftheImage) == 1
            aggregateListOftheImage(1).imageName = imageName{imageNum};
        end
        
        f = figure('Name', char(aggregateListOftheImage(1).imageName), 'visible', 'off');
        f.Position(3:4) = [1300 500];
        
        subplot(1, 2, 1);
        imagesc(currentImage);
        title('Original Image');
        
        colormap;
        colorbar;
        
        subplot(1, 2, 2);
        imagesc(aggregateImage);
        title('Identified aggregates');
        for j = 1:length(aggregateListOftheImage)
            % text((aggregateListOftheImage(j).CentroidPosX)+1, (aggregateListOftheImage(j).CentroidPosY)+7,['\color{red} ' num2str(aggregateListOftheImage(j).objectIndex)], 'FontSize', 4);
            x = round(aggregateListOftheImage(j).CentroidPosX);
            y = round(aggregateListOftheImage(j).CentroidPosY);
            
            if ~isnan(aggregateListOftheImage(j).CentroidPosX) == 1
                text(x-7, y,'O', 'Color', '#7E2F8E', 'FontSize', 10);
            end
        end
        colormap;
        colorbar;

        hold on
        saveas(gcf, [figPath '\' char(aggregateListOftheImage(1).imageName) '.png']);
        
        disp(['Saving figures ' num2str(round((imageNum/lengthList*100), 1)) ' %'])
    end
    close all
end