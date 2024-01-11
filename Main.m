
% Copyright (c) 2023, by Jason C Sang.

%% Setting

path = 'G:\Arabidopsis\20240110_Simpull_Syn_Serum dilution\240104-Q_X1-3_2024-01-10_18-58-11'; % Direct to the main folder to be analysed

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
        [outputImageList, mu, sigma] = backgroundSubtraction(averagedStacksList);

        disp('Finding aggregates..')
        objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma);
        [objectList, posList] = organizeObjectData(objects);
        filteredList = filterData(objectList);

        disp('Saving data..')
        dataPath = export(filteredList, Save_path, folderName);
        drawFigure(averagedStacksList, posList, dataPath, imageName);
    end
else
    folderPath = path;

    disp('Loading images from the current folder..')
    [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName] = readTIFF(folderPath, truncatedFrame);
    
    disp('Subtracting background..')
    [outputImageList, mu, sigma] = backgroundSubtraction(averagedStacksList);
    
    disp('Finding aggregates..')
    objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma);
    [objectList, posList] = organizeObjectData(objects);
    filteredList = filterData(objectList);
    
    disp('Saving data..')
    dataPath = export(filteredList, Save_path, folderName);
    drawFigure(averagedStacksList, posList, dataPath, imageName);
end

disp('Completed!')
toc