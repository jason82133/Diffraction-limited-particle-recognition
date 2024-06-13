
% Main_Thresholding
% Version 1.0
%
% Copyright (c) 2024, by Jason C Sang.



%% Setting
clearvars

path = 'C:\Users\jason\OneDrive - University of Cambridge\Analysis\20240510_Simpull_Syn_abeta_serum sample storage_3';

fileName = '1';

thresholdingRange = [90 100];

label = 'Thresholded quaterile 90%';


%% Import
disp('Importing data..(1/3)');

inputList = readtable([path, '\', fileName, '.csv'], "Delimiter", "comma");

uniqueList = cell(size(inputList,1),1);

for i = 1:size(inputList,1)
    uniqueList{i} = [char(inputList.slideName(i)) '_' char(inputList.imageName(i))];
end


% Use unique to get unique elements and their counts
[uniqueImage, firstImagePos, ~] = unique(uniqueList);
%[uniqueImage, firstImagePos, ~] = unique(Data_imageName);

thresholdedList = cell(size(inputList,1),1);

for tempNum = 1:size((thresholdedList),1)
    thresholdedList{tempNum} = 'None';
end



%% Thresholding objects from indivisual images
disp('Thresholding data..(2/3)');

for imageNum = 1:numel(uniqueImage)
    disp([num2str(round(imageNum/numel(uniqueImage)*100, 1)) ' %'])
    
    clear imagePos
    %imagePos = find(ismember(firstImagePos, find(ismember(uniqueList, uniqueImage{imageNum})))); % select the image and the specified well name
    imagePos = find(ismember(uniqueList, uniqueImage{imageNum}));

    tempList = zeros(numel(imagePos), 1);

    for j = 1:numel(imagePos)
        tempList(j) = inputList(imagePos(j),:).SB_diff;
    end 


    % Identify objects to be thresholded based on the filters given
    thresholdingList_SB_diff = ~isoutlier(tempList, "percentiles", thresholdingRange);
    
    % Find their positions
    thresholdingPosList_SB_diff = imagePos(thresholdingList_SB_diff);
    
    % if ~isempty(thresholdingPosList_SB_diff) == 1
    %     for k = 1:numel(thresholdingPosList_SB_diff)
    %         thresholdedPos{k} = find(ismember(thresholdedList, uniqueImage{thresholdingPosList_SB_diff(k)}));
    %     end
    % else
    %     thresholdedPos = [];
    % end
    
    % Label identified objects
    if ~isempty(thresholdingPosList_SB_diff) == 1
        for thresholedNum_b = 1:numel(thresholdingPosList_SB_diff)
            thresholdedList{thresholdingPosList_SB_diff(thresholedNum_b)} = label;
        end
    end
end

inputList.VarName = thresholdedList;
inputList = renamevars(inputList,'VarName', label);

%% Saving
disp('Saving data..(3/3)');

currentDateTime = datetime('now', 'Format', 'yyyy-MM-dd_HH-mm-ss');
timestampString = char(currentDateTime);

writetable(inputList, [path '\' timestampString '_Thresholded_' fileName '.csv']);

disp('Completed');
