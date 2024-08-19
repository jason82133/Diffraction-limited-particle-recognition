
% Diffraction-limited particle recognition (DLPR)
% Version 1.14.6
%
% Copyright (c) 2023, by Jason C Sang.



%% Setting

path = 'G:\Work\Artemisia\New folder'; % Direct to the main folder to be analysed

InstrumentSetting = 2; % Arabidopsis 638nm = 1, Artemisia 638nm = 2, Arabidopsis 488nm = 3

NeedResultFigure = 0; % Show result figures = 1, not showing = 0 and accelerate the analysis

truncatedFrame = []; % Remove the frames after the specified frame number in an image. Leave empty if analysing all frames



%% Execution

tic
clearvars -except path InstrumentSetting truncatedFrame NeedResultFigure

Save_path = path;

% To find all subfolders
allItems = dir(path);
subfolderNames = {allItems([allItems.isdir]).name};
subfolderNames = subfolderNames(~ismember(subfolderNames, {'.', '..'}));
if ~isempty(subfolderNames(strncmp(subfolderNames, 'Analysis', 8)))
    subfolderNames = subfolderNames(~ismember(subfolderNames, subfolderNames(strncmp(subfolderNames, 'Analysis', 8))));
end


if ~isempty(subfolderNames)
    for i = 1:numel(subfolderNames)
        clearvars -except path InstrumentSetting truncatedFrame NeedResultFigure subfolderNames allItems Save_path i

        folderPath = [path '\' subfolderNames{i}];

        disp(['Loading images from ' num2str(subfolderNames{i}) '..'])
        [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName, xName, yName] = readTIFF(folderPath, truncatedFrame);

        [outputImageList, mu, sigma, bg, smoothSize] = backgroundSubtraction(averagedStacksList, InstrumentSetting);

        objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma, bg, xName, yName);
        [objectList, posList] = organizeObjectData(objects);
        [filteredList, filteredPosList, areaThreshold] = filterData(objectList, posList);

        dataPath = export(filteredList, Save_path, folderName, areaThreshold, smoothSize);
        if NeedResultFigure == 1
            drawFigure(averagedStacksList, filteredPosList, dataPath, imageName);
        end
    end
else
    folderPath = path;

    disp('Loading images from the current folder..')
    [averagedStacksList, averagedFileNamesList, folderName, imageName, wellName, xName, yName] = readTIFF(folderPath, truncatedFrame);
    
    [outputImageList, mu, sigma, bg, smoothSize] = backgroundSubtraction(averagedStacksList, InstrumentSetting);
    
    objects = identifyObjects(outputImageList, folderName, imageName, wellName, mu, sigma, bg, xName, yName);
    [objectList, posList] = organizeObjectData(objects);
    [filteredList, filteredPosList, areaThreshold] = filterData(objectList, posList);
    
    dataPath = export(filteredList, Save_path, folderName, areaThreshold, smoothSize);
    if NeedResultFigure == 1
        drawFigure(averagedStacksList, filteredPosList, dataPath, imageName);
    end
end

disp('Completed!')
toc
