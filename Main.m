
% Diffraction-limited particle recognition (DLPR)
% Version 1.12
%
% Copyright (c) 2023, by Jason C Sang.



%% Setting

path = 'D:\Work\Arabidopsis\20240325_Simpull_abeta_antibody screening_641'; % Direct to the main folder to be analysed

InstrumentSetting = 1; % Arabidopsis 641nm = 1, Artemisia 641 nm = 2, Arabidopsis 488nm = 3

truncatedFrame = []; % Remove the frames after the specified frame number in an image. Leave empty if analysing all frames



%% Execution
clearvars -except path InstrumentSetting truncatedFrame

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
        [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName, xName, yName] = readTIFF(folderPath, truncatedFrame);

        disp('Subtracting background..')
        [outputImageList, mu, sigma, bg, smoothSize] = backgroundSubtraction(averagedStacksList, InstrumentSetting);

        disp('Finding aggregates..')
        objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma, bg, xName, yName);
        [objectList, posList] = organizeObjectData(objects);
        [filteredList, filteredPosList, areaThreshold] = filterData(objectList, posList);

        disp('Saving data..')
        dataPath = export(filteredList, Save_path, folderName, areaThreshold, smoothSize);
        drawFigure(averagedStacksList, filteredPosList, dataPath, imageName);
    end
else
    folderPath = path;

    disp('Loading images from the current folder..')
    [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName, xName, yName] = readTIFF(folderPath, truncatedFrame);
    
    disp('Subtracting background..')
    [outputImageList, mu, sigma, bg, smoothSize] = backgroundSubtraction(averagedStacksList, InstrumentSetting);
    
    disp('Finding aggregates..')
    objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma, bg, xName, yName);
    [objectList, posList] = organizeObjectData(objects);
    [filteredList, filteredPosList, areaThreshold] = filterData(objectList, posList);
    
    disp('Saving data..')
    dataPath = export(filteredList, Save_path, folderName, areaThreshold, smoothSize);
    drawFigure(averagedStacksList, filteredPosList, dataPath, imageName);
end

disp('Completed!')
toc