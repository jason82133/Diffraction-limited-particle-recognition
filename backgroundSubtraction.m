function [outputImageList, mu, sigma, smoothSize, pThreshold] = backgroundSubtraction(averagedStacksList)
    % Initialize cell array to store processed images
    outputImageList = cell(size(averagedStacksList));

    pThreshold = 0.05; % right-tailed 2 sigma

    % Loop through each z-averaged image
    for i = 1:numel(averagedStacksList)
        
        % Get the current z-averaged image
        currentImage = averagedStacksList{i};

        %currentImage = imresize(currentImage, 10,'nearest');
        %currentImage = imgaussfilt(currentImage, 1);
        
        % Top-hat filtering
        smoothSize = 3;
        se = strel('disk', smoothSize);
        currentImage = imtophat(currentImage, se);

        % First itinerary of fitting a normal distribution to the pixel intensities in order to remove extreme values
        % Flatten the image into a column vector
        tempintensities = currentImage(:);
        
        [temppd, tempMu, tempSigma] = normalDistribution(tempintensities);  
        tempCV = tempSigma/tempMu;

        % Apply multi-itinery fitting when images contain bad (extreme bright outliers) clusters that can distort the intensity distribution
        
        if tempCV > 5 % Take CV > 500% to distinguish bad fit results from good ones
           
            temppValues = 1 - cdf(temppd, tempintensities);

            % A course filter with right-sided p-value of 2 sigma that removes most of bright signal pixels in order to approximate normal distribution of the noises
            level = 0.05;
            outlierPixels = currentImage(temppValues >= level);
            tempImage = zeros(size(currentImage));
            tempImage(temppValues >= level) = outlierPixels;
            
            intensities = tempImage(tempImage ~=0); % new intensity distribution without extreme values; to be fitted

            oriintensities = tempImage(:);
        
            % Second itinerary of fitting a normal distribution to the pixel intensities
            [pd, mm, ss] = normalDistribution(intensities);
            
            mu(i) = mm;
            sigma(i) = ss;

            %pThreshold = 0.000622*mu(i)-0.467; % Based on linear regression background mean
            % if pThreshold > 0.3
            %     pThreshold = 0.3;
            % end
            % if pThreshold < 0.005
            %     pThreshold = 0.005;
            % end

            % Filter out pixels with right-sided p-value
            pValues = 1 - cdf(pd, oriintensities);
            filteredPixels = currentImage(pValues < pThreshold);
    
            % Create a new image with filtered pixels
            processedImage = zeros(size(currentImage));
            processedImage(pValues < pThreshold) = filteredPixels;

            
             % Post check if the pThreshold satisfies
            % postIntensities = processedImage(processedImage(:) ~= 0);
            % 
            % [postpd, postMu, postSigma] = normalDistribution(postIntensities);
            % 
            % postCV = postSigma/postMu;


            % while postCV <= 0.2 && pThreshold > 0.05 % Multi-itinerary to find an optimal pThreshold where the outstanding intensities do not include noises (the right tail area with broader x-range, CV of 20%)
            % 
            %     pThreshold = pThreshold - 0.05;
            %     if pThreshold > 0.3
            %         pThreshold = 0.3;
            %     end
            %     if pThreshold < 0.005
            %         pThreshold = 0.005;
            %     end
            % 
            %     % Filter out pixels with right-sided p-value
            %     pValues = 1 - cdf(pd, intensities);
            %     filteredPixels = currentImage(pValues < pThreshold);
            % 
            %     % Create a new image with filtered pixels
            %     processedImage = zeros(size(currentImage));
            %     processedImage(pValues < pThreshold) = filteredPixels;
            % 
            %     postIntensities = processedImage(processedImage(:) ~= 0);
            % 
            %     [postpd, postMu, postSigma] = normalDistribution(postIntensities);
            %     postCV = postSigma/postMu;
            % end

        else
            intensities = currentImage(:); % new intensity distribution without extreme values; to be fitted

            % Second itinerary of fitting a normal distribution to the pixel intensities
            [pd, mm, ss] = normalDistribution(intensities);
            
            mu(i) = mm;
            sigma(i) = ss;

            % pThreshold = 0.000622*mu(i)-0.467; % Based on linear regression background mean
            % if pThreshold > 0.3
            %     pThreshold = 0.3;
            % end
            % if pThreshold < 0.1
            %     pThreshold = 0.1;
            % end

            % Filter out pixels with right-sided p-value
            pValues = 1 - cdf(pd, intensities);
            filteredPixels = currentImage(pValues < pThreshold);
    
            % Create a new image with filtered pixels
            processedImage = zeros(size(currentImage));
            processedImage(pValues < pThreshold) = filteredPixels;

            % Post check if the pThreshold satisfies
            % postIntensities = processedImage(processedImage(:) ~= 0);
            % 
            % [postpd, postMu, postSigma] = normalDistribution(postIntensities);
            % 
            % postCV = postSigma/postMu;

            % while postCV <= 0.2 && pThreshold > 0.005 % Multi-itinerary to find an optimal pThreshold where the outstanding intensities do not include noises (the right tail area with broader x-range, CV of 20%)
            % 
            %     pThreshold = pThreshold - 0.05;
            %     if pThreshold > 0.3
            %         pThreshold = 0.3;
            %     end
            %     if pThreshold < 0.005
            %         pThreshold = 0.005;
            %     end
            % 
            %     % Filter out pixels with right-sided p-value
            %     pValues = 1 - cdf(pd, intensities);
            %     filteredPixels = currentImage(pValues < pThreshold);
            % 
            %     % Create a new image with filtered pixels
            %     processedImage = zeros(size(currentImage));
            %     processedImage(pValues < pThreshold) = filteredPixels;
            % 
            %     postIntensities = processedImage(processedImage(:) ~= 0);
            % 
            %     [postpd, postMu, postSigma] = normalDistribution(postIntensities);
            %     postCV = postSigma/postMu;
            % end
        end
        
        % % Smoothen the image with a 3x3 median filter
        smoothenedImage = medfilt2(processedImage, [smoothSize smoothSize]);

        % Create a new image with smoothened pixels
        outputImage = zeros(size(processedImage));
        outputImage((processedImage) > 0 & (smoothenedImage > 0)) = processedImage((processedImage) > 0 & (smoothenedImage > 0));
        
        % Store the processed image
        outputImageList{i} = outputImage;
    end
end