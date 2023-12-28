
% Copyright (c) 2023, by Jason C Sang.

%% Setting

% Direct to the folder to be analysed
path = 'G:\Arabidopsis\20231221_Simpull_Syn\Syn1-MJFR-1';




%% Execution
clearvars -except Save_path 

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
        [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName] = readTIFF(folderPath);

        disp('Subtracting background..')
        [outputImageList, mu, sigma] = backgroundSubtraction(averagedStacksList);

        disp('Finding aggregates..')
        objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma);
        [objectList, posList] = organizeObjectData(objects);
        filteredList = filterData(objectList);

        disp('Saving data..')
        dataPath = export(filteredList, Save_path, folderName);
        drawFigure(averagedStacksList, posList, dataPath);
    end
else
    folderPath = path;

    disp('Loading images from the current folder..')
    [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName] = readTIFF(folderPath);
    
    disp('Subtracting background..')
    [outputImageList, mu, sigma] = backgroundSubtraction(averagedStacksList);
    
    disp('Finding aggregates..')
    objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma);
    [objectList, posList] = organizeObjectData(objects);
    filteredList = filterData(objectList);
    
    disp('Saving data..')
    dataPath = export(filteredList, Save_path, folderName);
    drawFigure(averagedStacksList, posList, dataPath);
end

disp('Completed!')
toc