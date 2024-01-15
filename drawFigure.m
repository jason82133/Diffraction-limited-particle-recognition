function drawFigure(averagedStacksList, filteredPosList, dataPath, imageName)
    
    warning('off','MATLAB:MKDIR:DirectoryExists')
    figPath = [dataPath '\Figures'];
    mkdir(figPath);
    
    for imageNum = 1:numel(averagedStacksList)
        disp([num2str(imageNum/numel(averagedStacksList)*100) ' %'])

        clear currentImage

        % Display the original and processed images for comparison
        currentImage = averagedStacksList{imageNum};
        aggregateImage = zeros(size(currentImage));
        
        aggregateListOftheImage = struct('objectIndex', {}, 'CentroidPosX', {}, 'CentroidPosY', {}, 'imageNum', {}, 'imageName', {});
        for listNum = 1:numel(filteredPosList)
            if filteredPosList(listNum).imageNum == imageNum
                aggregateListOftheImage(end+1) = filteredPosList(listNum);
            end
        end


        for i = 1:length(aggregateListOftheImage)
            if ~isnan(aggregateListOftheImage(i).CentroidPosX) == 1
                x = aggregateListOftheImage(i).CentroidPosX;
                y = aggregateListOftheImage(i).CentroidPosY;
                aggregateImage(round(y), round(x)) = 1;  % Note the reversal of x and y here
            end
        end
        
        if isempty(aggregateListOftheImage) == 1
            disp(imageName{imageNum})
            aggregateListOftheImage(1).imageName = imageName{imageNum};
        end


        f = figure('Name',num2str(aggregateListOftheImage(1).imageName), 'visible', 'off');
        f.Position(3:4) = [1300 500];
        
        subplot(1, 2, 1);
        imagesc(currentImage);
        title('Original Image');
        
        colormap;
        colorbar;
        
        subplot(1, 2, 2);
        imagesc(aggregateImage);
        title('Identified ROIs');
        for j = 1:length(aggregateListOftheImage)
            text((aggregateListOftheImage(j).CentroidPosX)+1, (aggregateListOftheImage(j).CentroidPosY)+7,['\color{red} ' num2str(aggregateListOftheImage(j).objectIndex)], 'FontSize', 8);
        end
        colormap;
        colorbar;

        hold on
        saveas(gcf, [figPath '\' num2str(aggregateListOftheImage(1).imageName) '.png']);
    end
    close all
end