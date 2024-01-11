function [outputImageList, mu, sigma] = backgroundSubtraction(averagedStacksList)
    % Initialize cell array to store processed images
    outputImageList = cell(size(averagedStacksList));

    % Loop through each z-averaged image
    for i = 1:numel(averagedStacksList)
        % Get the current z-averaged image
        currentImage = averagedStacksList{i};



        % First itinerary of fitting a normal distribution to the pixel intensities in order to remove extreme values
        % Flatten the image into a column vector
        tempintensities = currentImage(:);
        
        temppd = fitdist(tempintensities, 'Normal');
        
        templowerThreshold = temppd.icdf(0.25);
        tempupperThreshold = temppd.icdf(0.75);
        tempIQR = tempupperThreshold - templowerThreshold;
        tempMu = (tempupperThreshold + templowerThreshold) / 2;
        tempSigma = tempIQR / 1.349;

        temppValues = 1 - cdf(temppd, tempintensities);
        outlierPixels = currentImage(temppValues >= 0.00000001);
        tempImage = zeros(size(currentImage));
        tempImage(temppValues >= 0.00000001) = outlierPixels;
        
        intensities = tempImage(:); % new intensity distribution without extreme values; to be fitted


        
        % Second itinerary of fitting a normal distribution to the pixel intensities
        pd = fitdist(intensities, 'Normal');

        % Estimate mean and variance using percentiles
        lowerPercentile = 25;
        upperPercentile = 75;
        lowerThreshold = pd.icdf(lowerPercentile / 100);
        upperThreshold = pd.icdf(upperPercentile / 100);
        
        % Calculate IQR (Interquartile Range)
        IQR = upperThreshold - lowerThreshold;
        
        % Estimate standard deviation for a normal distribution
        sigma(i) = IQR / 1.349;
        
        % Calculate mean using the median (assuming symmetry in a normal distribution)
        mu(i) = (upperThreshold + lowerThreshold) / 2;

        % Filter out pixels with right-sided p-value below 2.5 sigma 0.006%
        pThreshold = 0.05;
        pValues = 1 - cdf(pd, intensities);
        filteredPixels = currentImage(pValues < pThreshold);

        % Create a new image with filtered pixels
        processedImage = zeros(size(currentImage));
        processedImage(pValues < pThreshold) = filteredPixels;
        
        % Smoothen the image with a 3x3 median filter
        smoothenedImage = medfilt2(processedImage, [3 3]);
        
        % Create a new image with smoothened pixels
        outputImage = zeros(size(processedImage));
        outputImage((processedImage) > 0 & (smoothenedImage > 0)) = processedImage((processedImage) > 0 & (smoothenedImage > 0));
        
        % Store the processed image
        outputImageList{i} = outputImage;
    end
end