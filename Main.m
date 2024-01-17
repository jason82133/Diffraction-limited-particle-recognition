
% Copyright (c) 2023, by Jason C Sang.

%% Setting

path = 'G:\Arabidopsis\20240115_Simpull_Syn_Serum dilution'; % Direct to the main folder to be analysed

truncatedFrame = []; % Remove the frames after the specified frame number in an image. Leave empty if analysing all frames


%% Execution
clearvars -except path truncatedFrame

Save_path = path;

tic
% To find all subfolders
allItems = dir(path);
subfolderNames = {allItems([allItems.isdir]).name};
subfolderNames = subfolderNames(~ismember(subfolderNames, {'.', '..'}));
if ~isempty(subfolderNames(strncmp(subfolderNames, 'Analysis', 8)))
    subfolderNames = subfolderNames(~ismember(subfolderNames, subfolderNames(strncmp(subfolderNames, 'Analysis', 8))));
end


if ~isempty(subfolderNames)

    for i = 1:numel(subfolderNames)
        folderPath = [path '\' subfolderNames{i}];

        disp(['Loading images from ' num2str(subfolderNames{i}) '..'])
        [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName] = readTIFF(folderPath, truncatedFrame);

        disp('Subtracting background..')
        [outputImageList, mu, sigma, smoothSize] = backgroundSubtraction(averagedStacksList);

        disp('Finding aggregates..')
        objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma);
        [objectList, posList] = organizeObjectData(objects);
        [filteredList, filteredPosList, areaThreshold] = filterData(objectList, posList);

        disp('Saving data..')
        dataPath = export(filteredList, Save_path, folderName, smoothSize, areaThreshold);
        drawFigure(averagedStacksList, filteredPosList, dataPath, imageName);
    end
else
    folderPath = path;

    disp('Loading images from the current folder..')
    [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName] = readTIFF(folderPath, truncatedFrame);
    
    disp('Subtracting background..')
    [outputImageList, mu, sigma, smoothSize] = backgroundSubtraction(averagedStacksList);
    
    disp('Finding aggregates..')
    objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma);
    [objectList, posList] = organizeObjectData(objects);
    [filteredList, filteredPosList, areaThreshold] = filterData(objectList, posList);
    
    disp('Saving data..')
    dataPath = export(filteredList, Save_path, folderName, smoothSize, areaThreshold);
    drawFigure(averagedStacksList, filteredPosList, dataPath, imageName);
end

disp('Completed!')
toc