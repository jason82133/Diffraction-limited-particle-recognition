
% Generating a mask for binarisation.
function [outputImageList, mu, sigma, bg, smoothSize] = backgroundSubtraction(averagedStacksList)

    % Initialize cell array to store processed images
    outputImageList = cell(size(averagedStacksList));

    %pThreshold = 0.1; % right-tailed 2 sigma

    % Loop through each z-averaged image
    for i = 1:numel(averagedStacksList)
        
        % Get the current z-averaged image
        currentImage = averagedStacksList{i};
       
        % First itinerary of fitting a normal distribution to the pixel intensities in order to remove extreme values
        tempintensities = currentImage(:); % Flatten the image into a column vector
        
        % median value of the image as background
        bg(i) = median(tempintensities);

        [temppd, tempMu, tempSigma] = normalDistribution(tempintensities);  
        tempCV = tempSigma/tempMu;

        mu(i) = tempMu;
        sigma(i) = tempSigma;



        % Apply multi-itinery fitting when images contain bad (extreme bright outliers) clusters that can distort the intensity distribution
        if tempCV > 1 % Take CV > 100% to distinguish bad fit results from good ones
           
            temppValues = 1 - cdf(temppd, tempintensities);

            % A course filter with right-sided p-value of 2 sigma that removes most of bright signal pixels in order to approximate normal distribution of the noises
            level = 0.05;
            outlierPixels = currentImage(temppValues >= level);
            tempImage = zeros(size(currentImage));
            tempImage(temppValues >= level) = outlierPixels;
            
            %intensities = tempImage(tempImage ~=0); % new intensity distribution without extreme values; to be fitted

            currentImage = tempImage;
      
            % Top-hat filtering
            smoothSize = 3;
            se = strel('disk', smoothSize);
            currentImage = imtophat(currentImage, se);

            intensities = currentImage(:);

            % Second itinerary of fitting a normal distribution to the pixel intensities
            [pd, mm, ss] = normalDistribution(intensities);
        else
            % Top-hat filtering
            smoothSize = 3;
            se = strel('disk', smoothSize);
            currentImage = imtophat(currentImage, se);

            intensities = currentImage(:); % new intensity distribution without extreme values; to be fitted

            % Second itinerary of fitting a normal distribution to the pixel intensities
            [pd, mm, ss] = normalDistribution(intensities);
        end
        

        
        % Adaptive thresholding based on linear regression of image CV.
        % The CV considers the variation of intensity histogram which positively correlates to the number of spots
        pThreshold = 1.5924*tempCV-0.01847;
        if pThreshold > 0.3
            pThreshold = 0.3;
        end
        if pThreshold < 0.05
            pThreshold = 0.05;
        end

        % Filter out pixels with right-sided p-value
        pValues = 1 - cdf(pd, intensities);
        filteredPixels = currentImage(pValues < pThreshold);

        % Create a new image with filtered pixels
        processedImage = zeros(size(currentImage));
        processedImage(pValues < pThreshold) = filteredPixels;
        
        % % Smoothen the image with a 3x3 median filter
        smoothenedImage = medfilt2(processedImage, [smoothSize smoothSize]);

        % Create a new image with smoothened pixels
        outputImage = zeros(size(processedImage));
        outputImage((processedImage) > 0 & (smoothenedImage > 0)) = processedImage((processedImage) > 0 & (smoothenedImage > 0));
        
        % Store the processed image
        outputImageList{i} = outputImage;
    end
end