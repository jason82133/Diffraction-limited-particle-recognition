function [averagedStacks, averagedFileNames] = stackAverage(imageStacks, fileNames)
    % Initialize cell arrays to store averaged stacks and file names
    %averagedStacks = cell(size(imageStacks));
    %averagedFileNames = cell(size(fileNames));

    % Convert the cell array of images to a 4D array
    stackArray = cat(3, imageStacks(:,:,:));

    % Compute the average of the image stack along the fourth dimension (frames)
    averagedImage = mean(stackArray, 3);

    % Store the averaged image and update the file name
    averagedStacks = averagedImage;
    averagedFileNames = ['avg_' fileNames];
end
